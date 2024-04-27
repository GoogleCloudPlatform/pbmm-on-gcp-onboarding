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

### Clone Terraform Example Foundation repo
