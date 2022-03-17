#!/bin/bash
# /**
#  * Copyright 2019 Google LLC
#  *
#  * Copyright 2021 Google LLC. This software is provided as is, without
#  * warranty or representation for any use or purpose. Your use of it is
#  * subject to your agreement with Google.
#  */
###############################################################################
#                        Terraform top-level resources                        #
###############################################################################

set -e
export PLAN_FILE="launchpad.`date +%Y-%m-%d.%H%m`.plan"
export STATE_FILE="terraform.tfstate"
export LANDINGZONE_BRANCH="landingzone"

##############################################
# Run all steps in a row
# Globals:
#  PlAN_FILE
#  STATE_FILE
# Arguments:
#  None
##############################################
function run () {
 echo "INFO - Bootstrapping started"
 auth
 apply_roles
 create_branch
 remove_symlinks
 repair_symlinks
 replace_for_config
 tf_apply
 upload_statefile
 create_backends
 create_csr
 echo "INFO - Bootstrapping done"
}

##############################################
# Authenticates gcloud
# Globals: 
#  None
# Arguments: 
#  None
##############################################
function auth () {  
if ! gcloud config list --format json > /dev/null; then
 "ERROR - No gcloud config detected please run gcloud init or gcloud auth login"
 exit 1
fi

USER=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")

if [ -z "${USER}" ]; then
  echo "Login first with: gcloud auth login"
  gcloud auth application-default login
fi

USER=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")

source yaml.sh
create_variables "../../config/config.yaml"

DOMAIN=$domain

echo "User: ${USER}"
echo "Domain: ${DOMAIN}"
read -p "Is this the domain of the organization you want to deploy to? (y/n)"$'\n> ' -n 1 -r

if [[ $REPLY =~ ^[Nn]$ ]]; then
  read -p $'\n'"What is the domain of the organization you want to deploy to?"$'\n> ' -r
  DOMAIN=${REPLY}
fi
}

##############################################
# Checkout main branch into a temp local landingzone branch
# Globals: 
#  LANDINGZONE_BRANCH
# Arguments: 
#  None
##############################################
function create_branch () {
echo "INFO - Branching main branch to a temp landingzone branch"
local existed_in_local=$(git branch --list ${LANDINGZONE_BRANCH})
if [[ -z ${existed_in_local} ]]; then
  git checkout -b $LANDINGZONE_BRANCH
  echo "INFO - The temp landingzone branch built"
else
  git checkout $LANDINGZONE_BRANCH
  echo "INFO - Switched to the temp landingzone branch"
fi
}

##############################################
# Applies Roles based on domain and user email
# Globals: 
#  ORGNAME
#  ROLES
# Arguments: 
#  None
##############################################
function apply_roles () {
if [[ -z "$USER" ]]; then
  auth
fi

# Set Vars for Permissions application
ORGNAME=$(gcloud organizations list --format="get(name)" --filter=displayName=$DOMAIN)
ROLES=("roles/orgpolicy.policyAdmin" "roles/resourcemanager.folderCreator" "roles/resourcemanager.organizationViewer" "roles/resourcemanager.projectCreator" "roles/billing.projectManager" "roles/billing.admin" "roles/iam.serviceAccountTokenCreator" "roles/cloudbuild.builds.editor")

# Loop through each Role in Roles and apply to Organization node. 
echo "INFO - Applying roles to Organization Node"
for i in "${ROLES[@]}" ; do
  gcloud organizations add-iam-policy-binding $ORGNAME  --member=user:$USER --role=$i --quiet > /dev/null 1>&1
done
}

##############################################
# Replaces TFvars values for the values in the config.yaml file
# Globals:
#  USER
#  DOMAIN
##############################################
function replace_for_config () {
    echo "INFO - replace_for_config starting..."

    if [[ -z "$USER" ]]; then
      auth
    fi
    
    source gres.sh

    source yaml.sh
    create_variables "../../config/config.yaml"

    local orgid=$(gcloud organizations list --format="value(ID)" --filter=displayName="$DOMAIN")
    local directory_customer_id=$(gcloud organizations list --format="value(DIRECTORY_CUSTOMER_ID)" --filter=displayName="$DOMAIN")

    # Random value to be replaced where there is a need for unique names
    local rand=''
    if [ "$use_random_string" = true ]; then
      rand=$(((RANDOM + 10000)/10)) # generate a 4-digital random number.
    fi

    local files=$(find ../../config/TFvars -name '*.auto.tfvars'; find ../../config/YAML -name '*.yaml';)

    for file in ${files[*]}; do
      echo "INFO - Replacing variables at $file"

      local lower_additional_user_defined_string=$(echo $additional_user_defined_string | tr '[:upper:]' '[:lower:]')
      gres '<ADDITIONAL_USER_DEFINED_STRING>' "$lower_additional_user_defined_string" "$file"

      local audit_labels_replacement=""
      for i in ${!audit_labels__key[@]}; do
        # We do the below otherwise we get a 400 Bad Request error
        local audit_label_key=$(echo ${audit_labels__key[i]} | tr '[:upper:]' '[:lower:]')
        local audit_label_value=$(echo ${audit_labels__value[i]} | tr '[:upper:]' '[:lower:]' | tr '[:blank:]' '-')
        audit_labels_replacement="$audit_labels_replacement\n        $audit_label_key = \"$audit_label_value\""
      done
      gres '<AUDIT_LABELS>' "$audit_labels_replacement" "$file"

      gres '<BILLING_ACCOUNT>' "$billing_account" "$file"
      gres '<BOOTSTRAP_EMAIL>' "$USER" "$file"
      gres '<CLOUD_SOURCE_REPO_NAME>' "$cloud_source_repo_name" "$file"

      local contacts_replacement=""
      for contact in ${contacts[*]}; do
        contacts_replacement="$contacts_replacement\n    \"$contact\" = [\"ALL\"]"
      done
      gres '<CONTACTS>' "$contacts_replacement" "$file"

      gres '<DEPARTMENT_CODE>' "$department_code" "$file"
      gres '<DIRECTORY_CUSTOMER_ID>' "$directory_customer_id" "$file"
      gres '<DOMAIN>' "$DOMAIN" "$file"
      gres '<ENVIRONMENT>' "$environment" "$file"

      local nonprod_networking_labels_replacement=""
      for i in ${!nonprod_network_labels__key[@]}; do
        # We do the below otherwise we get a 400 Bad Request error
        local nonprod_networking_label_key=$(echo ${nonprod_network_labels__key[i]} | tr '[:upper:]' '[:lower:]')
        local nonprod_networking_label_value=$(echo ${nonprod_network_labels__value[i]} | tr '[:upper:]' '[:lower:]' | tr '[:blank:]' '-')
        nonprod_networking_labels_replacement="$nonprod_networking_labels_replacement\n        $nonprod_networking_label_key = \"$nonprod_networking_label_value\""
      done
      gres '<NON_PROD_NETWORK_LABELS>' "$nonprod_networking_labels_replacement" "$file"

      local organization_labels_replacement=""
      for i in ${!organization_labels__key[@]}; do
        organization_labels_replacement="$organization_labels_replacement\n    \"${organization_labels__key[i]}\" = \"${organization_labels__value[i]}\""
      done
      gres '<ORGANIZATION_LABELS>' "$organization_labels_replacement" "$file"

      gres '<ORGID>' "$orgid" "$file"
      gres '<OWNER>' "$owner" "$file"
      gres '<RAND>' "$rand" "$file"
      gres '<USER_DEFINED_STRING>' "$user_defined_string" "$file"

      echo "INFO - Variables at $file replaced!"
    done
    
    echo "INFO - replace_for_config done!"
}  

##############################################
# Applies terraform code based on plan file
# Globals: 
#  STATE_FILE
#  PLAN_FILE
# Arguments: 
#  None
##############################################
function tf_apply () {
echo "INFO - Running a plan to ensure the configuration file is correct"
terraform init
#terraform plan -var-file=../../config/organization-config.tfvars -var-file=../../config/bootstrap.tfvars -state=${STATE_FILE} -out=${PLAN_FILE}
terraform plan -state=${STATE_FILE} -out=${PLAN_FILE}
{
  echo "Please confirm that you have reviewed the plan and wish to apply it. Type 'yes' to proceed";
  read ;
  echo "";
  if [ "${REPLY}" != "yes" ] ; then
    echo "INFO - User did not approve plan. Exiting"
    exit 0
  fi
}

# Apply
echo "INFO - Applying Terraform plan"
terraform apply -parallelism=30 -state=${STATE_FILE} ${PLAN_FILE}
}

##############################################
# Collects state information and uploads statefile to the new buckets
# Globals: 
#  STATE_FILE
# Arguments: 
#  None
##############################################
function upload_statefile () {
COMMON_BUCKET=$(terraform output -state=${STATE_FILE} -json | jq -r '.tfstate_bucket_names.value.common' )
NONPROD_BUCKET=$(terraform output -state=${STATE_FILE} -json | jq -r '.tfstate_bucket_names.value.nonprod')
PROD_BUCKET=$(terraform output -state=${STATE_FILE} -json | jq -r '.tfstate_bucket_names.value.prod')
PROJECT_ID=$(terraform output  -state=${STATE_FILE} -json | jq -r '.project_id.value')

STATE_TO_UPLOAD=`find \\. -name ${STATE_FILE}`
STATE_FILE_PATH="environments/bootstrap"
STATE_FILE_EXISTS=$(gsutil -q stat gs://${COMMON_BUCKET}/${STATE_FILE_PATH}/default.tfstate || echo 1)
if [[ ${STATE_FILE_EXISTS} == 1 && "${STATE_TO_UPLOAD}" != "" ]]; then
  # Upload file to storage
  # Container - tfstate (hard code and must align to core_infrastructure/bootstrap/terraform.tfvars)
  echo "INFO - Uploading ${STATE_TO_UPLOAD} to ${COMMON_BUCKET}/${STATE_FILE_PATH} ${PROJECT_ID}"
  gsutil cp ${STATE_TO_UPLOAD} gs://${COMMON_BUCKET}/${STATE_FILE_PATH}/default.tfstate
fi
}

#####################################################################
# backend
# Writes a backend.tf file to the environment after bootstrap 
# inputs:
# $1: relative path from bootstrap
# $2: bucket name parsed from state file
# $3: 
# $4: prefix corresponding to bootstrap state
# $5: prefix correspond to common state
# outputs: 
#  $1/backend.tf file written
#####################################################################
function backend () {
#TF_SVC_ACCT=$(terraform output -state=${STATE_FILE} -json |jq -r '.service_account_email.value')
TF_SVC_ACCT=$(jq -r .outputs.service_account_email.value ${STATE_FILE})
cat << EOF > ${1}/backend.tf

terraform {
  backend "gcs" {
    bucket = "${2}"
    prefix = "${3}"
  }
}

data "terraform_remote_state" "bootstrap" {
    backend = "gcs"
    config = {
      bucket = "${2}"
      prefix = "${4}"
    }  
}

data "terraform_remote_state" "common" {
    backend = "gcs"
    config = {
      bucket = "${2}"
      prefix = "${5}"
    }
}

EOF
cat << EOF > ${1}/provider.tf
provider "google" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google-beta" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google" {
  access_token = data.google_service_account_access_token.default.access_token
}
provider "google-beta" {
  access_token = data.google_service_account_access_token.default.access_token

}
provider "null" {

}
data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = "${TF_SVC_ACCT}"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1800s"
}
EOF
}

function provider () {
TF_SVC_ACCT=$(jq -r .outputs.service_account_email.value ${STATE_FILE})
cat << EOF > ${1}/provider.tf
provider "google" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google-beta" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google" {
  access_token = data.google_service_account_access_token.default.access_token
}
provider "google-beta" {
  access_token = data.google_service_account_access_token.default.access_token

}
provider "null" {

}
data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = "${TF_SVC_ACCT}"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1800s"
}

EOF
}
##############################################
# creates backends
# Globals: 
#  STATE_FILE
# Arguments: 
#  None
##############################################
function create_backends () {
if [ -f "$STATE_FILE" ]; then
    echo "Terraform $STATE_FILE exists."
COMMON_BUCKET=$(jq -r '.outputs.tfstate_bucket_names.value.common' ${STATE_FILE})
TF_SVC_ACCT=$(jq -r '.outputs.service_account_email.value' ${STATE_FILE})
BOOTSTRAP_STATE_PREFIX="environments/bootstrap"
COMMON_STATE_PREFIX="environments/common"
NONPROD_STATE_PREFIX="environments/nonprod"
PROD_STATE_PREFIX="environments/prod"

echo "INFO - Create bootstrap backend"
cat << EOF > ./backend.tf
terraform {
  backend "gcs" {
    bucket = "${COMMON_BUCKET}"
    prefix = "${BOOTSTRAP_STATE_PREFIX}"
  }
}
EOF
echo "INFO - Create common backend"
cat << EOF > ../common/backend.tf
terraform {
  backend "gcs" {
    bucket = "${COMMON_BUCKET}"
    prefix = "${COMMON_STATE_PREFIX}"
  }
}
data "terraform_remote_state" "bootstrap" {
    backend = "gcs"
    config = {
      bucket = "${COMMON_BUCKET}"
      prefix = "${BOOTSTRAP_STATE_PREFIX}"
    }
}
EOF

# create downstream environment versions
# backend PATH STATE_BUCKET ENV_PREFIX BOOTSTRAP_PREFIX COMMON_PREFIX
echo "INFO - Create common provider"
provider "../common"
echo "INFO - Create nonprod backend and provider"
backend "../nonprod" $COMMON_BUCKET $NONPROD_STATE_PREFIX $BOOTSTRAP_STATE_PREFIX $COMMON_STATE_PREFIX
provider "../nonprod"
echo "INFO - Create prod backend and provider"
backend "../prod" $COMMON_BUCKET $PROD_STATE_PREFIX $BOOTSTRAP_STATE_PREFIX $COMMON_STATE_PREFIX
provider "../prod"

else 
    echo "$STATE_FILE does not exist. Apply terraform first to generate local statefile. "
    exit 1
fi 
}

##############################################
# Creates git mirror and pushes to Cloud Source Repository
# Globals: 
#  STATE_FILE
# Arguments: 
#  None
##############################################
function create_csr () {
  echo "INFO - Committing code to CSR"
  # Read csr and project id from state file to variables.
  CLOUD_SOURCE_REPO=$(jq -r '.outputs.csr_name.value' ${STATE_FILE}) || echo "ERROR - Issue finding repo value in statefile"
  PROJECT_ID=$(jq -r '.outputs.project_id.value' ${STATE_FILE}) || echo "ERROR - Issue finding project_id value in statefile"
  # Cleanup symbolic links
  remove_symlinks
  echo "INFO - All symbolic links under $(pwd) are removed"
  # Validate variable values
  [[ -z "$CLOUD_SOURCE_REPO" || "$CLOUD_SOURCE_REPO" == "null" ]] && { echo "Error: CSR name not found in ${STATE_FILE}"; exit 1; }
  [[ -z "$PROJECT_ID"  || "$PROJECT_ID" == "null" ]] && { echo "Error: Project ID not found in ${STATE_FILE}"; exit 1; }
  # Commit code changes
  env -i git add -A && git commit -m "bootstrap run `date +%Y-%m-%d.%H%m`" || echo "ERROR - Error committing changes to git" 
  echo "INFO - Check if CSR is already a git remote"
  # Add csr if it doesn't exist
  if ! git config remote.csr.url > /dev/null; then
    echo "INFO - CSR is not a remote, adding it"
    env -i git remote add csr "https://source.developers.google.com/p/${PROJECT_ID}/r/${CLOUD_SOURCE_REPO}"
  fi
  # Replace csr if incorrect
  NEWURL=$(env -i git config remote.csr.url)
  read -p "INFO - Is this URL correct? ${NEWURL} (y/n) `echo $'\n> '`" -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "INFO - Use the url: ${NEWURL}"
  else
    env -i git remote remove csr
    read -p "INFO - Enter the url: https://source.developers.google.com/p/PROJECT_ID/r/CLOUD_SOURCE_REPO `echo $'\n> '`" 
    env -i git remote add csr $REPLY
  fi
  # Replace csr if malformed
  echo "INFO - Check if CSR is malformed"
  URL=$(git config remote.csr.url)
  MALURL="\/p\/\S+\/r\/\S+"
  if [[ ! $URL =~ $MALURL ]]; then
    echo "WARN - CSR was malformed ${URL}"
    env -i git remote remove csr
    env -i git remote add csr "https://source.developers.google.com/p/${PROJECT_ID}/r/${CLOUD_SOURCE_REPO}"
    echo "INFO - CSR was updated $(env -i git config remote.csr.url)"
  fi
  # Pushing code to CSR
  CSRURL=$(env -i git config remote.csr.url)
  echo "INFO - Pushing code to CSR: ${CSRURL}"
  env -i git push -u csr ${LANDINGZONE_BRANCH}:main
  # Rebuild symbolic links
  repair_symlinks
  # Commit code changes after repairing symlinks
  env -i git add -A && git commit -m "Repaired symlinks `date +%Y-%m-%d.%H%m`" || echo "ERROR - Error committing changes to git" 
}

##############################################
# Pushes code and moves Build Triggers to another Git repository
##############################################
function use_another_repo () {
  repair_symlinks
  terraform init
  local project_id=$(terraform state pull | jq -r '.outputs.project_id.value')
  local current_cloud_source_repo_name=$(terraform state pull | jq -r '.outputs.csr_name.value')
  echo "INFO - PROJECT_ID: $project_id"
  echo "INFO - Build Triggers currently connected to the following CSR Repository: $current_cloud_source_repo_name"
  echo "INFO - We will ask you for the target Git repository name you would like to use. It can be a CSR repository, or an external repository."
  echo "INFO - If it is an external repository, please go to https://source.cloud.google.com/repo/connect to connect it to CSR before proceeding."
  read -n 1 -p "INFO - After the repository is in CSR, press ANY key to continue...$(echo $'\n')"
  read -p "INFO - Enter the name of the target CSR Repository: $(echo $'\n> ')"
  local target_cloud_source_repo_name=$(echo "$REPLY" | xargs)
  # Prepare to rename landing_zone_bootstrap.google_sourcerepo_repository.csr and move its Build Triggers to the target repository
  terraform state rm module.landing_zone_bootstrap.google_sourcerepo_repository.csr || true # Because the state could be already removed
  terraform import module.landing_zone_bootstrap.google_sourcerepo_repository.csr "projects/$project_id/repos/$target_cloud_source_repo_name"
  # Replacing the cloud_source_repo_name in bootstrap.auto.tfvars: terraform doesn't support using -var for nested variables yet
  sed -i -e "s/cloud_source_repo_name.*/cloud_source_repo_name      = \"$target_cloud_source_repo_name\"/g" ../../config/TFvars/bootstrap/bootstrap.auto.tfvars
  terraform validate
  terraform apply || { echo "ERROR - In case of transient '443: connect: cannot assign requested address' error, please try running this script again."; exit 1; }
  # Cleanup symbolic links
  remove_symlinks
  echo "INFO - All symbolic links under $(pwd) are removed"
  echo "INFO - We will ask you for the target Git repository url"
  echo "INFO - For CSR, the url format is https://source.developers.google.com/p/PROJECT_ID/r/CLOUD_SOURCE_REPO"
  echo "INFO - For Github, make sure you are authenticated to push to the remote url (for information on remote urls, see https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#about-remote-repositories). To use a SSH urls, for example, you can refer to https://docs.github.com/en/authentication/connecting-to-github-with-ssh. To use a HTTPS urls, you can refer to https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token for more information."
  # Getting and validating the Target Repository URL
  echo "INFO - Validating that the target repository exists and that you have permission to push to it..."
  local is_valid_target_repo_url=false
  while ! $is_valid_target_repo_url; do
    read -p "INFO - Enter the target repository url: $(echo $'\n> ')"
    local target_repo_url=$(echo "$REPLY" | xargs)
    env -i git ls-remote "$target_repo_url" && is_valid_target_repo_url=true || echo "Invalid target repository url $target_repo_url. Please input a valid url."
  done
  echo "INFO - target repository url $is_valid_target_repo_url validated!"
  # Commit code changes
  env -i git add -A && git commit -m "bootstrap use_another_repo $(date +%Y-%m-%d.%H%m)" || { echo "ERROR - Error committing changes to git"; exit 1; }
  echo "INFO - Replacing csr remote..."
  env -i git remote remove csr
  env -i git remote add csr "$target_repo_url"
  echo "INFO - Pushing code to $target_repo_url"
  env -i git push csr "${LANDINGZONE_BRANCH}:main"
  echo "INFO - Code pushed to $target_repo_url."
  repair_symlinks
  echo "INFO - Done. You can check the Build Triggers at https://console.cloud.google.com/cloud-build/triggers?project=$PROJECT_ID"
}

##############################################
# Destroys all the environments
##############################################
function destroy () {
    echo "WARN - This script will destroy ALL environments!"
    echo "WARN - To proceed with destroying ALL the environments, type 'yes'." 
    read ;
    echo "";
    if [ "${REPLY}" != "yes" ] ; then
        echo "INFO - User did not proceed. Exiting"
        exit 0
    fi

    local environment_dirs=('../prod' '../nonprod' '../common')

    for environment in ${environment_dirs[*]}; do
        terraform -chdir="$environment" init 
        local tf_state_list=$(terraform -chdir="$environment" state list)
        if [ -z "$tf_state_list" ]
        then
            echo "INFO - $environment already destroyed!"
        else
            echo "INFO - Destroying $environment..."
            terraform -chdir="$environment" destroy --auto-approve
            echo "INFO - $environment destroyed!"
        fi
    done

    echo "INFO - Destroying bootstrap..."
    local backend_file='backend.tf'
    local backend_file_backup='backend.tf.backup'

    if [ -f "$backend_file" ]
    then
        terraform init 
        terraform state pull > "$STATE_FILE"
        # To use the local file as state
        mv "$backend_file" "$backend_file_backup"
        terraform init -migrate-state
    fi

    terraform destroy --auto-approve
    rm "$backend_file_backup"
    echo "INFO - bootstrap destroyed!"

    echo "INFO - destroy done!"
}

function repair_symlinks () {
  echo "INFO - repairing symlinks"
  cd ../../modules/naming-standard/modules/gcp
  cd ./compute_address_external_ip && ln -snf ../../common/module/common.tf common.tf 
  cd ../managed_disk_data && ln -snf ../../common/module/common_bypass_prefix.tf common_bypass_prefix.tf
  cd ../vpn_tunnel_name && ln -snf ../../common/module/common.tf common.tf 
  cd ../cloud_scheduler_job && ln -snf ../../common/module/common.tf common.tf 
  cd ../container_registry_image && ln -snf ../../common/module/common.tf common.tf 
  cd ../route && ln -snf ../../common/module/common_bypass_prefix.tf common_bypass_prefix.tf
  cd ../subnet && ln -snf ../../common/module/common_bypass_prefix.tf common_bypass_prefix.tf
  cd ../region_backend_service && ln -snf ../../common/module/common.tf common.tf 
  cd ../cloudbuild_trigger && ln -snf ../../common/module/common.tf common.tf 
  cd ../virtual_machine && ln -snf ../../common/module/common.tf common.tf 
  cd ../managed_disk_os && ln -snf ../../common/module/common_bypass_prefix.tf common_bypass_prefix.tf
  cd ../virtual_private_cloud && ln -snf ../../common/module/common.tf common.tf 
  cd ../nat && ln -snf ../../common/module/common.tf common.tf 
  cd ../firewall_rule && ln -snf ../../common/module/common.tf common.tf 
  cd ../folder/ && ln -snf ../../common/module/common_optional_prefix.tf common_optional_prefix.tf
  cd ../custom_role && ln -snf ../../common/module/common.tf common.tf 
  cd ../ha_vpn_name && ln -snf ../../common/module/common.tf common.tf 
  cd ../storage && ln -snf ../../common/module/common.tf common.tf 
  cd ../generic_resource_name && ln -snf ../../common/module/common.tf common.tf 
  cd ../project && ln -snf ../../common/module/common.tf common.tf 
  cd ../forwarding_rule && ln -snf ../../common/module/common.tf common.tf 
  cd ../cloud_function && ln -snf ../../common/module/common.tf common.tf 
  cd ../external_vpn_name && ln -snf ../../common/module/common.tf common.tf 
  cd ../log_sink && ln -snf ../../common/module/common.tf common.tf 
  cd ../service_account && ln -snf ../../common/module/common.tf common.tf 
  cd ../compute_address_internal_ip && ln -snf ../../common/module/common.tf common.tf 
  cd ../virtual_machine_instance_group && ln -snf ../../common/module/common.tf common.tf 
  cd ../vpc_svc_ctl && ln -snf ../../common/module/common.tf common.tf 
  cd ../health_check && ln -snf ../../common/module/common.tf common.tf 
  cd ../router && ln -snf ../../common/module/common.tf common.tf
  echo "repaired use this command to check: "
  echo "ls -lR | grep ^l"
  echo "INFO - gcp symlinks repaired"
  # repair auto.tfvars links for default workspace.
  cd ../../../../../environments/bootstrap
  ln -snf ../../config/TFvars/bootstrap/bootstrap.auto.tfvars bootstrap.auto.tfvars
  ln -snf ../../config/TFvars/bootstrap/organization-config.auto.tfvars organization-config.auto.tfvars
  cd ../common
  ln -snf ../../config/TFvars/common/common.auto.tfvars common.auto.tfvars
  cd ../nonprod
  ln -snf ../../config/TFvars/nonprod/nonp-firewall.auto.tfvars nonp-firewall.auto.tfvars
  ln -snf ../../config/TFvars/nonprod/nonp-network.auto.tfvars nonp-network.auto.tfvars
  ln -snf ../../config/TFvars/nonprod/nonp-vpc-svc-ctl.auto.tfvars nonp-vpc-svc-ctl.auto.tfvars
  cd ../prod
  ln -snf ../../config/TFvars/prod/fortigate-firewall.auto.tfvars fortigate-firewall.auto.tfvars
  ln -snf ../../config/TFvars/prod/perimeter-network.auto.tfvars perimeter-network.auto.tfvars
  ln -snf ../../config/TFvars/prod/prod-firewall.auto.tfvars prod-firewall.auto.tfvars
  ln -snf ../../config/TFvars/prod/prod-network.auto.tfvars prod-network.auto.tfvars
  ln -snf ../../config/TFvars/prod/prod-private-perimeter-firewall.auto.tfvars prod-private-perimeter-firewall.auto.tfvars
  ln -snf ../../config/TFvars/prod/prod-public-perimeter-firewall.auto.tfvars prod-public-perimeter-firewall.auto.tfvars
  ln -snf ../../config/TFvars/prod/prod-vpc-svc-ctl.auto.tfvars prod-vpc-svc-ctl.auto.tfvars
  cd ../bootstrap
  echo "INFO - auto.tfvars symlinks repaired"
}

function remove_symlinks () {
  echo "INFO - removing symlinks"
  # remove links about gcp modules
  cd ../../modules/naming-standard/modules/gcp
  find . -name "common*.tf" -delete
  # remove links of auto.tfvars
  cd ../../../../environments/bootstrap
  find .. -name "*.auto.tfvars" -delete
  echo "INFO - symlinks removed"
}

function cleanup () {
  echo "INFO - cleaning "
  # clean runtime and dynamically generated files from all root modules from here.
  rm -rf ./.terraform
  rm -rf ../common/.terraform
  rm -rf ../nonprod/.terraform
  rm -rf ../prod/.terraform
  find .. -name ".terraform.*" -delete
  find .. -name "*.tfstate*" -delete
  find .. -name "*.plan" -delete
  echo "INFO - cleaned"
}

if [ $# -eq 0 ]; then
  echo "Options are: run, auth, apply_roles, create_branch, replace_for_config, tf_apply, upload_statefile, create_backends, repair_symlinks, remove_symlinks, create_csr; use_another_repo; destroy
; Select run for full bootstrap"
  exit 1
else
case $1 in
  run)
  run
  ;;
  
  auth)
  auth
  ;;

  apply_roles)
  apply_roles
  ;;

  create_branch)
  create_branch
  ;;

  replace_for_config)
  replace_for_config
  ;;

  tf_apply)
  tf_apply
  ;;

  upload_statefile)
  upload_statefile
  ;;

  create_backends)
  create_backends
  ;;

  create_csr)
  create_csr
  ;;

  use_another_repo)
  use_another_repo
  ;;

  destroy)
  destroy
  ;;

  repair_symlinks)
  repair_symlinks
  ;;

  remove_symlinks)
  remove_symlinks
  ;;

  cleanup)
  cleanup
  ;;

esac
fi
