# Resource hierarchy customizations

This document contains guidance for customizing resource hierarchy during Terraform Foundation Example blueprint deployment.

The current deployment scenario of Terraform Foundation Example blueprint considers a flat resource hierarchy where all folders are at the same level and have one folder for each environment. Here is a detailed explanation of each folder:

| Folder | Description |
| --- | --- |
| bootstrap | Contains the seed and CI/CD projects that are used to deploy foundation components. |
| common | Contains projects with common resources used by the organization like logging, SCC and hybrid connectivity. |
| production | Environment folder that contains projects with cloud resources that have been promoted into production. |
| non-production | Environment folder that contains a replica of the production environment to let you test workloads before you put them into production. |
| development | Environment folder that is used as a development and sandbox environment. |

This document covers a scenario where you can have two or more levels of folders, with an environment-centric focus: `environments -> ... -> business units`.

| Current Hierarchy | Changed Hierarchy |
| --- | --- |
| <pre>example-organization/<br>├── fldr-bootstrap<br>├── fldr-common<br>├── <b>fldr-development *</b><br>├── <b>fldr-non-production *</b><br>└── <b>fldr-production *</b><br></pre> | <pre>example-organization/<br>├── fldr-bootstrap<br>├── fldr-common<br>├── <b>fldr-development *</b><br>│   ├── finance<br>│   └── retail<br>├── <b>fldr-non-production *</b><br>│   ├── finance<br>│   └── retail<br>└── <b>fldr-production *</b><br>    ├── finance<br>    └── retail<br></pre> |

## Code Changes - Build Files

Review the `tf-wrapper.sh`. It is a bash script helper responsible for applying  terraform configurations for Terraform Foundation Example blueprint. The `tf-wrapper.sh` script works based on the current branch (see [Branching strategy](../README.md#branching-strategy)) and searches for a folder in the source code where name matches the current branch name. When it finds a folder it applies the terraform configurations. These changes below will make `tf-wrapper.sh` capable of searching deeper for matching folders and complying with your source code folder hierarchy.

1. Create a new variable `maxdepth` to set how many source folder levels should be searched for terraform configurations.

    ```text
    ...
    tmp_plan="${base_dir}/tmp_plan"
    environments_regex="^(development|non-production|production|shared)$"

    #🟢 Create maxdepth variable
    maxdepth=2  #🟢 Must be configured based in your directory design

    #🟢 Create component temp variables
    current_component=""
    old_component=""

    ...
    ```

1. Create the new function `check_env_path_folder` between new variables and already existing `tf_apply` function.

    ```text
    ...
    current_component=""
    old_component=""

    #🟢 New check_env_path_folder function

    ## Fix component name to be different for each environment. It is used as tf-plan file name
    check_env_path_folder() {
    local lenv_path=$1
    local lbase_dir=$2
    local lcomponent=$3
    local lenv=$4

    if [[ "$lenv_path" =~ ^($lbase_dir)/(.+)/$lenv ]] ; then
        # The ${BASH_REMATCH[2]} means the second group in regex expression
        # This group is the folders between base dir and env
        # This value guarantees that tf-plan file name will be unique for each environment
        current_component=$(echo ${BASH_REMATCH[2]} | sed -r 's/\//-/g')
    else
        current_component=$lcomponent
    fi
    }

    #🟢 End of New check_env_path_folder function


    ## Terraform apply for single environment.
    tf_apply() {
    ...
    ```

1. Change `find "$component_path"` command in `tf_plan_validate_all` function to set the new maxdepth variable.

    ```text
    tf_plan_validate_all() {
    local env
    local component
    find "$base_dir" -mindepth 1 -maxdepth 1 -type d \
    -not -path "$base_dir/modules" \
    -not -path "$base_dir/.terraform" | while read -r component_path ; do
        component="$(basename "$component_path")"

        #🟢 Set maxdepth in find command -------------- 🟢
        find "$component_path" -mindepth 1 -maxdepth $maxdepth -type d | while read -r env_path ; do
            env="$(basename "$env_path")"
    ```

1. Add handling component variable and call to new function `check_env_path_folder`.

    ```text
            env="$(basename "$env_path")"

            old_component=$component #🟢 Holds component value before call check_env_path_folder

            #🟢 Calls check_env_path_folder to get fixed component value
            check_env_path_folder "$env_path" "$base_dir" "$component" "$env"

            component=$current_component #🟢 Get fixed component value
            ...
            if [[ "$env" =~ $environments_regex ]] ; then
    ```

1. Fix warning message for not matching directories.

    ```text
        ...
        tf_plan "$env_path" "$env" "$component"
        tf_validate "$env_path" "$env" "$policysource" "$component"
      else
        #🟢 Replace dash (-) for slash (/) in component to fix warning message
        echo "$(echo ${component} | sed -r 's/-/\//g' )/$env doesn't match $environments_regex; skipping"
      fi

      component=$old_component #🟢 Assign old component value before next while-loop iteration
    done
    ```

1. Change `find "$component_path"` command in `single_action_runner` function to set the new maxdepth variable.

    ```text
    single_action_runner() {
    local env
    local component
    find "$base_dir" -mindepth 1 -maxdepth 1 -type d \
    -not -path "$base_dir/modules" \
    -not -path "$base_dir/.terraform" | while read -r component_path ; do
        component="$(basename "$component_path")"
        # sort -r is added to ensure shared is first if it exists.

        #🟢 Set maxdepth in find command -------------- 🟢
        find "$component_path" -mindepth 1 -maxdepth $maxdepth -type d | sort -r | while read -r env_path ; do
            env="$(basename "$env_path")"
    ```

1. Add handling component variable and call to new function `check_env_path_folder`.

    ```text
            env="$(basename "$env_path")"

            old_component=$component #🟢 Holds component value before call check_env_path_folder

            #🟢 Calls check_env_path_folder to get fixed component value
            check_env_path_folder "$env_path" "$base_dir" "$component" "$env"

            component=$current_component #🟢 Get fixed component value
    ...
    ```

1. Fix warning message for doesn't match directories.

    ```text
        esac
      else
        #🟢 Replace dash (-) for slash (/) in component to fix warning message
        echo "$(echo ${component} | sed -r 's/-/\//g' )/${env} doesn't match ${branch}; skipping"
      fi

      #🟢 Assign old component value before next while-loop iteration
      component=$old_component
    done
    ```

## Code Changes - Terraform Files

<pre>
example-organization/
├── bootstrap
├── common
├── <b>development *</b>
│   ├── finance
│   └── retail
├── <b>non-production *</b>
│   ├── finance
│   └── retail
└── <b>production *</b>
    ├── finance
    └── retail
</pre>

*Example 1 - An example of Terraform Foundation Example with hierarchy changed*

### Step 2-environments

1. Create the folder hierarchy for the business units in `env_baseline` module to it be equally replicated through all environments.

    Example:

    2-environments/modules/env_baseline/folders.tf

    ```text
    ...
    /******************************************
        Environment Folder
    *****************************************/

    resource "google_folder" "env" {
        display_name = "${local.folder_prefix}-${var.env}"
        parent       = local.parent
    }

    /* 🟢 Folder hierarchy creation */
    resource "google_folder" "finance" {
        display_name = "finance"
        parent       = google_folder.env.name
    }

    resource "google_folder" "retail" {
        display_name = "retail"
        parent       = google_folder.env.name
    }
    ...
    ```

1. Create an output with a flat representation of the new hierarchy in `env_baseline` module.

    *Table 1 - Example output for Example 1 resource hierarchy*

    | Folder Path | Folder Id |
    | --- | --- |
    | development | folders/0000000 |
    | development/finance | folders/11111111 |
    | development/retail | folders/2222222 |

    *Table 2 - Example output for resource hierarchy with more levels*

    | Folder Path | Folder Id |
    | --- | --- |
    | development | folders/0000000 |
    | development/us | folders/11111111 |
    | development/us/finance | folders/2222222 |
    | development/us/retail | folders/3333333 |
    | development/europe | folders/4444444 |
    | development/europe/finance | folders/5555555 |
    | development/europe/retail | folders/7777777 |

    Example:

    2-environments/modules/env_baseline/outputs.tf

    ```text
    ...
    /* 🟢 Folder hierarchy output */
    output "folder_hierarchy" {
        description = "Map with a flat representation of the new folder hierarchy where projects should be created."
        value       = {
        "${google_folder.env.display_name}" = google_folder.env.name
        "${google_folder.env.display_name}/finance" = google_folder.finance.name
        "${google_folder.env.display_name}/retail" = google_folder.retail.name
        }
    }
    ```

1. Create an output with the flat representation of the new hierarchy from the `env_baseline` module in each environment. It will be used in the next steps to host GCP projects.

    Example:

    2-environments/envs/development/outputs.tf

    ```text
    ...
    /* 🟢 Folder hierarchy output */
    output "folder_hierarchy" {
        description = "Map with a flat representation of the new folder hierarchy where projects should be created."
        value       = module.env.folder_hierarchy
    }
    ```

1. Proceed with deployment.

### Step 4-projects

1. Change the base_env module to receive the new folder key (e.g. development/retail) in the hierarchy map from step 2-environments.
1. This folder key should be used to get the folder where projects should be created.
    Example:

    4-projects/modules/base_env/variables.tf

    ```text
    ...
    /* 🟢 Folder Key variable */
    variable "folder_hierarchy_key" {
        description = "Key of the folder hierarchy map to get the folder where projects should be created."
        type = string
        default = ""
    }
    ...
    ```

    4-projects/modules/base_env/main.tf

    ```text
    locals {
        ...
        /* 🟢 Get new folder */
        env_folder_name = lookup(
        data.terraform_remote_state.environments_env.outputs.folder_hierarchy, var.folder_hierarchy_key
        , data.terraform_remote_state.environments_env.outputs.env_folder)
        ...
    }
    ...
    ```

1. Create your source code folder hierarchy above environment folders (development, non-production, production). Remember to keep the source code environment folders as leaves (latest level) in the source code folder hierarchy because this is the way `tf-wrapper.sh` - the bash script helper - works to apply terraform configurations.
1. Manually duplicate your source folder hierarchy to match your needs.
1. **(Optional)** To simplify the below changes renaming business_units here is helper script. **Remember to review the changes**. The below script assumes you are in `gcp-projects` folder:

    ```bash
    for i in `find "./business_unit_1" -type f -not -path "*/.terraform/*" -name '*.tf'`; do sed -i "s/bu1/<YOUR BUSINESS UNIT CODE>/" $i; done

    for i in `find "./business_unit_1" -type f -not -path "*/.terraform/*" -name '*.tf'`; do sed -i "s/business_unit_1/<YOUR BUSINESS UNIT NAME>/" $i; done

    for i in `find "./business_unit_2" -type f -not -path "*/.terraform/*" -name '*.tf'`; do sed -i "s/bu2/<YOUR BUSINESS UNIT CODE>/" $i; done

    for i in `find "./business_unit_2" -type f -not -path "*/.terraform/*" -name '*.tf'`; do sed -i "s/business_unit_2/<YOUR BUSINESS UNIT NAME>/" $i; done

    for i in `find "./business_unit_<NEW BUSINESS UNIT NUMBER>" -type f -not -path "*/.terraform/*" -name '*.tf'`; do sed -i "s/bu<NEW BUSINESS UNIT NUMBER>/<YOUR BUSINESS UNIT CODE>/" $i; done

    for i in `find "./business_unit_<NEW BUSINESS UNIT NUMBER>" -type f -not -path "*/.terraform/*" -name '*.tf'`; do sed -i "s/business_unit_<NEW BUSINESS UNIT NUMBER>/<YOUR BUSINESS UNIT NAME>/" $i; done
    ```

1. For this example, just rename folders business_unit_1 and business_unit_2 to your Business Units names, i.e: finance and retail, to match the example folder hierarchy.





1. Change backend gcs prefix for each business unit shared resources.
    Example:

    4-projects/finance/shared/backend.tf

    ```text
    ...
    terraform {
        backend "gcs" {
            bucket = "<YOUR_PROJECTS_BACKEND_STATE_BUCKET>"

            /* 🟢 Review prefix path */
            prefix = "terraform/projects/finance/shared"
        }
    }
    ```

1. Review local `repo_names` values in Cloud Build project pipelines. This name must match `sa_roles` key in base_shared_vpc_project module variable in `4-projects/modules/base_env/example_base_shared_vpc_project.tf`. The current pattern for this value is `"${var.business_code}-example-app"`.
1. Review business code in Cloud Build project pipelines.
    Example:

    4-projects/finance/shared/example_infra_pipeline.tf

    ```text
    locals {
        /* 🟢 Review locals */
        repo_names = ["fin-example-app"]
    }
    ...

    module "app_infra_cloudbuild_project" {

        /* 🟢 Review module path */
        source = "../../modules/single_project"
        ...
        primary_contact   = "example@example.com"
        secondary_contact = "example2@example.com"

        /* 🟢 Review business code */
        business_code     = "fin"
    }
    ```

1. Change backend gcs prefix for each business unit environment.
    Example:

    4-projects/finance/development/backend.tf

    ```text
    ...
    terraform {
        backend "gcs" {
            bucket = "<YOUR_PROJECTS_BACKEND_STATE_BUCKET>"

            /* 🟢 Review prefix path */
            prefix = "terraform/projects/finance/development"
        }
    }
    ```

1. Review business_code and business_unit to match your new business unit names.
1. Set new folder_hierarchy_key parameter on base_env calls.

    Example:

    4-projects/finance/development/main.tf

    ```text
    module "env" {
        /* 🟢 Review module path */
        source = "../../modules/base_env"

        env                  = "development"

        /* 🟢 Review business code */
        business_code        = "fin"
        business_unit        = "finance"

        /* 🟢 Set folder key parameter */
        folder_hierarchy_key = "fldr-development/finance"
        ...
    }
    ```

1. Proceed with deployment.
