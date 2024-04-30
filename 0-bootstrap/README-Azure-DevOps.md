Note: this is a WIP under https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/399

# Deploying an Azure DevOps CI/CD compatible environment

The objective of the following instructions is to configure the infrastructure that allows CI/CD deployments using
Azure DevOps for the deploy of the Terraform Example Foundation stages (`0-bootstrap`, `1-org`, `2-environments`, `3-networks`, `4-projects`, `5-app-infra`).
This infrastructure deployed consists of two GCP projects (`prj-b-seed` and `prj-b-cicd-wif`).

It is a best practice to have two separate projects here (`prj-b-seed` and `prj-b-cicd-wif`) for separation of concerns for terraform.
`prj-b-seed` stores terraform state and has the Service Accounts able to create/modify infrastructure.
The authentication infrastructure using [Workload identity federation](https://cloud.google.com/iam/docs/workload-identity-federation) is implemented in `prj-b-cicd-wif`.

## Prerequisites
To run the instructions described in this document, install the following:
- You have followed instructions in [README.md#prerequisites](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/0-bootstrap/README.md#prerequisites)

## Optional - Automatic creation of Google Cloud Identity groups
- You have followed instructions in [README.md#optional---automatic-creation-of-google-cloud-identity-groups](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/0-bootstrap/README.md#optional---automatic-creation-of-google-cloud-identity-groups)

  
Also make sure that you have the following:
- A Microsoft Account
- An Azure Account
- An Azure DevOps Organization and subscription - https://learn.microsoft.com/en-us/azure/devops/organizations/billing/overview?view=azure-devops
- A private Azure DevOps project (repository) for each one of the stages of Foundation and one for the ADO runner docker image:
    - Bootstrap
    - Organization
    - Environments
    - Networks
    - Projects
    - CI/CD Runner
- A Personal access token or a Group access token configured with the following scopes:
    - api
    - read_api
    - create_runner
    - read_repository
    - write_repository
    - read_registry
    - write_registry

# Instructions
see https://cloud.google.com/dotnet/docs/creating-a-cicd-pipeline-azure-pipelines-cloud-run


## Draft - references from GCP as ENV variables to ADO
- cloudbuild_project_id = "prj-b-cicd-82vv"
- seed_project_id = "prj-b-seed-8919"
- gcs_bucket_tfstate = "bkt-prj-b-seed-tfstate-7120"
- projects_gcs_bucket_tfstate = "bkt-prj-b-seed-8919-gcp-projects-tfstate"
- bootstrap_step_terraform_service_account_email = "sa-terraform-bootstrap@prj-b-seed-8919.iam.gserviceaccount.com"
- organization_step_terraform_service_account_email = "sa-terraform-org@prj-b-seed-8919.iam.gserviceaccount.com"
- projects_step_terraform_service_account_email = "sa-terraform-proj@prj-b-seed-8919.iam.gserviceaccount.com"
- environment_step_terraform_service_account_email = "sa-terraform-env@prj-b-seed-8919.iam.gserviceaccount.com"

## Draft - Artifacts - Manual

### Create ADO Project

<img width="1472" alt="Screenshot 2024-04-29 at 11 05 21" src="https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/assets/24765473/f47c909f-5383-477d-8110-2ab1e4433769">

### Import base PBMM Repository
Repos | Import
for example - import https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding.git into https://dev.azure.com/obrienlabsxyz/pbmm-on-gcp-onboarding/_git/pbmm-on-gcp-onboarding

<img width="1471" alt="Screenshot 2024-04-29 at 11 10 09" src="https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/assets/24765473/43084d8a-fb7a-40bc-bc64-7c21677db5c7">

Fork ADO repo will be of the form https://your-org@dev.azure.com/your-org/pbmm-on-gcp-onboarding/_git/pbmm-on-gcp-onboarding

### Switch to the main branch - or a branch under active development
```
git checkout main
```

### Generate GIT Credentials on the ADO repo

### Clone the public ADO repository into your local environment
For local gcloud environment authentication setup - see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/wiki/DevOps#authenticate-a-local-cloud-shell

```
# replace YOUR-ORG with your ado organization
git clone https://YOUR-ORG@dev.azure.com/YOUR-ORG/pbmm-on-gcp-onboarding/_git/pbmm-on-gcp-onboarding
cd pbmm-on-gcp-onboarding/0-bootstrap
```

### Create 5 additional private GCP repos below
see Repos / Files / Dropdown
<img width="1463" alt="Screenshot 2024-04-29 at 12 18 26" src="https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/assets/24765473/6514201f-854e-477b-9eb1-2265eda2999f">


gcp-bootstrap, gcp-policies, gcp-organization, gcp-networks, gcp-projects

<img width="1465" alt="Screenshot 2024-04-30 at 12 46 03" src="https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/assets/24765473/7ece5ead-2e94-4788-b8a0-5042a8e77361">

<img width="1456" alt="Screenshot 2024-04-30 at 12 46 30" src="https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/assets/24765473/cd437d57-d73c-4ed4-bb87-2d3a93f5f6ff">

#### gcp-bootstrap
1. Clone the private gcp-bootstrap repository you created to host the 0-bootstrap terraform configuration at the same level of the pbmm-on-gcp-onboarding folder.

local gcloud example
```
michaelobrien@mbp7 _deploy_test_399_from_ado % git clone https://obrienlabsxyz@dev.azure.com/obrienlabsxyz/pbmm-on-gcp-onboarding/_git/gcp-bootstrap gcp-bootstrap
Cloning into 'gcp-bootstrap'...
remote: Azure Repos
remote: Found 3 objects to send. (23 ms)
Unpacking objects: 100% (3/3), 736 bytes | 368.00 KiB/s, done.
michaelobrien@mbp7 _deploy_test_399_from_ado % cd gcp-bootstrap 
michaelobrien@mbp7 gcp-bootstrap % ls
README.md
michaelobrien@mbp7 gcp-bootstrap % git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean

```
1. The layout should be:
```
gcp-bootstrap/
pbmm-on-gcp-onboarding/
```

1. Navigate into the repo. All subsequent steps assume you are running them from the gcp-bootstrap directory. If you run them from another directory, adjust your copy paths accordingly.

```
cd gcp-bootstrap
```
1. Verify branch is correct - switch if necessary
```
michaelobrien@mbp7 _deploy_test_399_from_ado % cd gcp-bootstrap
michaelobrien@mbp7 gcp-bootstrap % git status
On branch 243-tef-retrofit
Your branch is up to date with 'origin/243-tef-retrofit'.

nothing to commit, working tree clean
michaelobrien@mbp7 gcp-bootstrap % git checkout gh399-ado
branch 'gh399-ado' set up to track 'origin/gh399-ado'.
Switched to a new branch 'gh399-ado'

```

#### gcp-policies
#### gcp-organization
#### gcp-networks
#### gcp-projects




### Optionally: Downgrade Terraform to 1.3.10
- see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/374
- https://releases.hashicorp.com/terraform/1.3.10/terraform_1.3.10_darwin_arm64.zip
- 
```
which terraform
/Users/michaelobrien/opt/google-cloud-sdk/bin/terraform
terraform --version
Terraform v1.3.0
```
upgrade in this case to 1.3.10 - download from https://releases.hashicorp.com/terraform/1.3.10/terraform_1.3.10_darwin_arm64.zip
```
ichaelobrien@mbp7 _deploy_test_399_from_ado % mkdir terraform
michaelobrien@mbp7 _deploy_test_399_from_ado % cd terraform 
michaelobrien@mbp7 terraform % cp ~/Downloads/terraform_1.3.10_darwin_arm64.zip .
michaelobrien@mbp7 terraform % unzip terraform_1.3.10_darwin_arm64.zip 
Archive:  terraform_1.3.10_darwin_arm64.zip
  inflating: terraform               
michaelobrien@mbp7 terraform % ls
terraform				terraform_1.3.10_darwin_arm64.zip
michaelobrien@mbp7 terraform % which terraform
/Users/michaelobrien/opt/google-cloud-sdk/bin/terraform
michaelobrien@mbp7 terraform % cp terraform /Users/michaelobrien/opt/google-cloud-sdk/bin/terraform
michaelobrien@mbp7 terraform % terraform --version                                                 
Terraform v1.3.10
```



in progress below ....
### Rename terraform.example.tfvars to terraform.tfvars and update the file with values from your environment:
```
mv terraform.example.tfvars terraform.tfvars
```
### Optionally: Use the helper script validate-requirements.sh to validate your environment:

### Run terraform init and terraform plan and review the output.
Note: cb.tf is commented out and not in use (specific to GCP Cloud Build) - it is replaced by ado.tf.example

### Service Accounts for ADO
- create a GCP service account for use by ADO with the following storage role - to be able to read the terraform remote state file from GCP GCS.

On your GCP console (tef-olapp is an example bootstrap project below only as in tef-"short domain name - for distinct id - here obrienlabs.app is olapp")
```
gcloud config set project tef-olapp
gcloud iam service-accounts create ado-sa --display-name="ado-sa" --project=tef-olapp
export PROJECT_ID=tef-olapp
export SA_EMAIL=ado-sa@$PROJECT_ID.iam.gserviceaccount.com
echo $SA_EMAIL
  ado-sa@tef-olapp.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/storage.admin --project=$PROJECT_ID
Updated IAM policy for project [tef-olapp].
```
#### Generate service account key
```
cloud iam service-accounts keys create ado-sa.json --iam-account $SA_EMAIL --project=$PROJECT_ID
tr -d '\n' < ado-sa.json > ado-sa-oneline.json
```
- Export the secret token on this SA for use by the ADO pipelines


### Setup Agents
#### Ask Azure for a request to increase free parallelism in Azure DevOps.
this will take an average of 2 days
- https://learn.microsoft.com/en-us/answers/questions/477716/how-to-resolve-no-hosted-parallelism-has-been-purc
- https://aka.ms/azpipelines-parallelism-request
- https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR5zsR558741CrNi6q8iTpANURUhKMVA3WE4wMFhHRExTVlpET1BEMlZSTCQlQCN0PWcu
#### Create a PAT (Personnal Access Token) in ADO for use by pipeline agents
User Settings | Security | PAT
#### Optionally use local agents
Until the free parallelism request gets approved create and use local agents on one of your machines or VMs.
- project settings | agent pools | add self-hosted

Windows example (powershell)
```
mkdir agent ; cd agent
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$HOME\Downloads\vsts-agent-win-x64-3.238.0.zip", "$PWD")
.\config.cmd

PS C:\opt\agent> .\run.cmd
Scanning for tool capabilities.
Connecting to the server.
2024-04-24 03:43:31Z: Listening for Jobs
```
#### Add PAT to the local agent
make sure to add a trailing slash in the url / - see https://learn.microsoft.com/en-us/answers/questions/272411/vs30063-you-are-not-authorized-to-access-https-dev
```
>> Connect:
Enter server URL > https://dev.azure.com/obrienlabsxyz/
Enter authentication type (press enter for PAT) >
Enter personal access token > ****************************************************
Connecting to server ...

>> Register Agent:
Enter agent pool (press enter for default) > olxyz-self
Enter agent name (press enter for 13900D) >
Scanning for tool capabilities.
Connecting to the server.
Successfully added the agent
Testing agent connection.
Enter work folder (press enter for _work) >
2024-04-24 03:34:21Z: Settings Saved.
Enter run agent as service? (Y/N) (press enter for N) > y
Enter enable SERVICE_SID_TYPE_UNRESTRICTED for agent service (Y/N) (press enter for N) > y
Enter User account to use for the service (press enter for NT AUTHORITY\NETWORK SERVICE) >
Granting file permissions to 'NT AUTHORITY\NETWORK SERVICE'.
Service vstsagent.obrienlabsxyz.olxyz-self.13900D successfully installed
Service vstsagent.obrienlabsxyz.olxyz-self.13900D successfully set recovery option
Service vstsagent.obrienlabsxyz.olxyz-self.13900D successfully set to delayed auto start
Service vstsagent.obrienlabsxyz.olxyz-self.13900D successfully set SID type
Service vstsagent.obrienlabsxyz.olxyz-self.13900D successfully configured
Enter whether to prevent service starting immediately after configuration is finished? (Y/N) (press enter for N) > y
```
If needed - while using a temporary local agent - force the pool
```
pool: olxyz-self
#  vmImage: ubuntu-latest
#  agent.name: 13900D
```

### Create 6 private ADO repositories
- gcp-bootstrap
- gcp-environments
- gcp-networks
- gcp-org
- gcp-policies
- gcp-projects

### Container Registry
The following repository can be temporarily replaced by links to a global/public dockerhub image at 
- https://hub.docker.com/repository/docker/obrienlabs/terraform-example-foundation-ado/tags
- tf-cloudbuilder is replaced by the following line in the pipeline yml
```
# https://hub.docker.com/r/obrienlabs/terraform-example-foundation-ado/tags
docker run obrienlabs/terraform-example-foundation-ado:0.0.2 --version
````
  

### ADO Logs and Artifacts
By default ADO will log entries and retain artifacts from ADO Pipeline runs for
- bootstrap
- env
- net
- org
- proj

## Draft - Artifacts - Automated
WIP sh script automation
## Draft - references to GCP

## Clone Terraform Example Foundation repo

## Procedure to periodically pull from upstream
```
git remote add upstream https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding.git
git fetch upstream
git merge upstream/main main
git push origin main
```
