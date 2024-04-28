Note: this is a WIP under https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/399

# Deploying an Azure DevOps CI/CD compatible environment

The objective of the following instructions is to configure the infrastructure that allows CI/CD deployments using
Azure DevOps for the deploy of the Terraform Example Foundation stages (`0-bootstrap`, `1-org`, `2-environments`, `3-networks`, `4-projects`, `5-app-infra`).
This infrastructure deployed consists of two GCP projects (`prj-b-seed` and `prj-b-cicd-wif`).

It is a best practice to have two separate projects here (`prj-b-seed` and `prj-b-cicd-wif`) for separation of concerns for terraform.
`prj-b-seed` stores terraform state and has the Service Accounts able to create/modify infrastructure.
The authentication infrastructure using [Workload identity federation](https://cloud.google.com/iam/docs/workload-identity-federation) is implemented in `prj-b-cicd-wif`.

To run the instructions described in this document, install the following:
- You have followed instructions in [README.md#prerequisites](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/0-bootstrap/README.md#prerequisites)


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

## Instructions


### Draft - references from GCP as ENV variables to ADO
- cloudbuild_project_id = "prj-b-cicd-82vv"
- seed_project_id = "prj-b-seed-8919"
- gcs_bucket_tfstate = "bkt-prj-b-seed-tfstate-7120"
- projects_gcs_bucket_tfstate = "bkt-prj-b-seed-8919-gcp-projects-tfstate"
- bootstrap_step_terraform_service_account_email = "sa-terraform-bootstrap@prj-b-seed-8919.iam.gserviceaccount.com"
- organization_step_terraform_service_account_email = "sa-terraform-org@prj-b-seed-8919.iam.gserviceaccount.com"
- projects_step_terraform_service_account_email = "sa-terraform-proj@prj-b-seed-8919.iam.gserviceaccount.com"
- environment_step_terraform_service_account_email = "sa-terraform-env@prj-b-seed-8919.iam.gserviceaccount.com"

### Draft - Artifacts - Manual

### Service Accounts for ADO
- create a GCP service account for use by ADO with the following storage role - to be able to read the terraform remote state file from GCP GCS.
- Export the secret token on this SA for use by the ADO pipelines
- 
#### Create 6 repositories
- gcp-bootstrap
- gcp-environments
- gcp-networks
- gcp-org
- gcp-policies
- gcp-projects

The following repository can be temporarily replaced by links to a global/public dockerhub image at https://hub.docker.com/repository/docker/obrienlabs/terraform-example-foundation-ado/tags
- tf-cloudbuilder

#### ADO Logs and Artifacts
By default ADO will log entries and retain artifacts from ADO Pipeline runs for
- bootstrap
- env
- net
- org
- proj

### Draft - Artifacts - Automated
WIP sh script automation
### Draft - references to GCP

### Clone Terraform Example Foundation repo
