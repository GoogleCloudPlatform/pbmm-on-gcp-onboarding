# Landing Zone Bootstrap Project
This modules is designed to work with the requirements for the [GCP Landing
Zone](https://bitbucket.org/sourcedgroup/gcp-foundations-live-infra). 

This module provides:
- Bootstrap Project
- Cloud Build
- Service account used to deploy Landing Zone infrastructure
- Set roles on the SA
- Buckets used to store Terraform State
- Permissions on bucket for a user to upload the Bootstrap Terraform state.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_user\_defined\_string | Additional user defined string. | `string` | `""` | no |
| billing\_account | billing account ID | `string` | n/a | yes |
| bootstrap\_email | Email of user:me@domain.com or group:us@domain.com to apply permissions to upload the state to the bucket once project as been created | `string` | n/a | yes |
| default\_region | n/a | `string` | `"northamerica-northeast1"` | no |
| department\_code | Code for department, part of naming module | `string` | n/a | yes |
| environment | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| location | location for naming and resource placement | `string` | `"northamerica-northeast1"` | no |
| org\_id | ID alone in the for of ##### to create the deploy account | `string` | n/a | yes |
| owner | Division or group responsible for security and financial commitment. | `string` | n/a | yes |
| parent | folder/#### or organizations/### to place the project into | `string` | n/a | yes |
| sa\_org\_iam\_permissions | List of permissions granted to Terraform service account across the GCP organization. | `list(string)` | `[]` | no |
| services | List of services to enable on the bootstrap project required for using their APIs | `list(string)` | n/a | yes |
| set\_billing\_iam | Disable for unit test as the SA is a Billing User. Requires Billing Administrator | `bool` | `true` | no |
| terraform\_deployment\_account | Service Account name | `string` | n/a | yes |
| tfstate\_buckets | Map of buckets to store Terraform state files | <pre>map(<br>    object({<br>      name          = string,<br>      labels        = optional(map(string)),<br>      force_destroy = optional(bool),<br>      storage_class = optional(string),<br>    })<br>  )</pre> | n/a | yes |
| user\_defined\_string | User defined string. | `string` | n/a | yes |
| yaml\_config\_bucket | Map with config bucket params | <pre>object({<br>    name          = string,<br>    labels        = optional(map(string)),<br>    force_destroy = optional(bool),<br>    storage_class = optional(string),<br>  })</pre> | n/a | yes |
| yaml\_config\_bucket\_writers | list of Groups/SA/Users in the form of user:me@domain.com | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | n/a |
| service\_account\_email | n/a |
| tfstate\_bucket\_names | n/a |
| yaml\_config\_bucket | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Created Resources

### Principals and Roles

| Principal | Project Level Roles | Optional Project Level Roles | Organization Level Roles |
|-----------|---------------------|------------------------------|--------------------------|
| `bootstrap_email` | `roles/source.admin` on `cloud_source_repo_name`<br><br>`roles/storage.admin` on `tfstate_buckets` |||
| `cloud_build_admins`| `roles/cloudbuild.builds.editor`<br><br>`roles/viewer` ||
| [Cloud Build Service Account](https://cloud.google.com/build/docs/cloud-build-service-account) | `roles/artifactregistry.writer` on Artifact Registry Repository<br>`roles/iam.serviceAccountTokenCreator`, impersonating the `terraformDeploymentAccount`<br><br>`roles/source.writer` on `cloud_source_repo_name`<br><br>`roles/storage.admin` on Cloud Build Artifacts Storage Bucket<br>`roles/storage.admin` on `tfstate_buckets`<br><br>`roles/storage.objectCreator` on `tfstate_buckets` | `roles/billing.user` on `billing_account`<br><br>`roles/secretmanager.secretAccessor`<br><br>`roles/source.admin` | `roles/accesscontextmanager.policyAdmin`<br><br>`roles/billing.user`<br><br>`roles/compute.admin`<br><br>`roles/compute.networkAdmin`<br><br>`roles/compute.xpnAdmin`<br><br>`roles/iam.organizationRoleAdmin`<br><br>`roles/iam.securityAdmin`<br><br>`roles/iam.serviceAccountAdmin`<br><br>`roles/logging.configWriter`<br><br>`roles/orgpolicy.policyAdmin`<br><br>`roles/resourcemanager.folderAdmin`<br><br>`roles/resourcemanager.organizationViewer`<br><br>`roles/resourcemanager.projectCreator`<br><br>`roles/resourcemanager.projectDeleter`<br><br>`roles/serviceusage.serviceUsageAdmin`<br><br>`roles/storage.admin` |
| `group_build_viewers` | `roles/cloudbuild.builds.viewer`<br><br>`roles/storage.objectViewer` |`roles/serviceusage.serviceUsageConsumer`|
| `terraformDeploymentAccount` | `roles/artifactregistry.admin` on Artifact Registry Repository<br>`roles/cloudbuild.builds.editor`<br><br>`roles/source.writer` on `cloud_source_repo_name`<br><br>`roles/storage.admin`<br><br>`roles/storage.objectCreator` on `tfstate_buckets`<br><br>`roles/storage.objectViewer` on the Cloud Build Artifacts Storage Bucket | `roles/billing.user` on `billing_account` | `roles/accesscontextmanager.policyAdmin`<br><br>`roles/billing.user`<br><br>`roles/compute.admin`<br><br>`roles/compute.networkAdmin`<br><br>`roles/compute.xpnAdmin`<br><br>`roles/iam.organizationRoleAdmin`<br><br>`roles/iam.securityAdmin`<br><br>`roles/iam.serviceAccountAdmin`<br><br>`roles/logging.configWriter`<br><br>`roles/orgpolicy.policyAdmin`<br><br>`roles/resourcemanager.folderAdmin`<br><br>`roles/resourcemanager.organizationViewer`<br><br>`roles/resourcemanager.projectCreator`<br><br>`roles/resourcemanager.projectDeleter`<br><br>`roles/serviceusage.serviceUsageAdmin`<br><br>`roles/storage.admin`|

### Enabled APIs

* [`accesscontextmanager.googleapis.com`](https://cloud.google.com/access-context-manager/docs/reference), 
* [`artifactregistry.googleapis.com`](https://cloud.google.com/artifact-registry/docs/reference/rest), 
* [`cloudbilling.googleapis.com`](https://cloud.google.com/billing/docs/reference/rest), 
* [`cloudbuild.googleapis.com`](https://cloud.google.com/build/docs/api/reference/rest), 
* [`cloudkms.googleapis.com`](https://cloud.google.com/kms/docs/reference/rest), 
* [`cloudresourcemanager.googleapis.com`](https://cloud.google.com/resource-manager/reference/rest), 
* [`iam.googleapis.com`](https://cloud.google.com/iam/docs/reference/rest), 
* [`logging.googleapis.com`](https://cloud.google.com/logging/docs/reference/api-overview), 
* [`secretmanager.googleapis.com`](https://cloud.google.com/secret-manager/docs/reference/rest), 
* [`serviceusage.googleapis.com`](https://cloud.google.com/service-usage/docs/reference/rest), 
* [`sourcerepo.googleapis.com`](https://cloud.google.com/source-repositories/docs/reference/rest)
* +Additional ones defined by the `services` variable.

### Resources

| User Defined Variable | Resource | Objective |
|-----------------------|----------|-----------| 
| N/A | [Artifact Registry Repository]((https://cloud.google.com/artifact-registry/docs/overview)) | Store the Terraform runner Docker images used by Cloud Build  |
| N/A | Cloud Build Artifacts Storage Bucket | Store the artifacts generated by Cloud Build |
| `cloud_build_config` | [Cloud Build Triggers](https://cloud.google.com/build/docs/automating-builds/create-manage-triggers) that run builds based on the [cloudbuild-pull-request.yaml](../../modules/cloudbuild/templates/cloudbuild-pull-request.yaml)  file on *Pull Requests* to the branch `main` | Continuous Integration |
| `cloud_build_config` | [Cloud Build Triggers](https://cloud.google.com/build/docs/automating-builds/create-manage-triggers) that run builds based on the [cloudbuild-push-request.yaml](../../modules/cloudbuild/templates/cloudbuild-pull-request.yaml)  file on *Push*es to the branch `main` | Continuous Integration |
| `cloud_source_repo_name` | [Cloud Source Repository](https://cloud.google.com/source-repositories/) |  Host the codebase generated by `bootstrap run` |
| `tfstate_buckets` | [Storage Buckets](https://cloud.google.com/storage/docs) | Store the [Terraform state](https://www.terraform.io/language/state) |
| N/A | Setup [OS Login](https://cloud.google.com/compute/docs/oslogin/) | [Benefits of OS Login](https://cloud.google.com/compute/docs/oslogin#:~:text=instances%20or%20projects.-,Benefits%20of%20OS%20Login,level%20by%20setting%20IAM%20permissions.) | Best Practice

### Actions

| Action | Objective |
|--------|-----------|
| Submits the [Terraform builder](../../modules/cloudbuild/cloudbuild_builder) to the Artifact Registry | Repeatable Builds. See [information on Cloud Builders](https://cloud.google.com/build/docs/cloud-builders). | 
