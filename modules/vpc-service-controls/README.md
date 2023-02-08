# GCP VPC Service Controls Module
This modules is designed to work with the requirements for the GCP Landing Zone. 

To get a more thorough understanding of how to use this module review the GCP
documentation for  [Access Context
Manager](https://cloud.google.com/access-context-manager/docs) and [VPC Service
Controls](https://cloud.google.com/vpc-service-controls/docs/overview)

## Created Resources

### Organization Access Policy
An organization can only have once Access Context Manager Policy. The module can
create the policy or use an existing one. If the `policy_id` variable is
supplied, the module will use the the `policy_id` not will not attempt to create
a new one. The `policy_name` variable will be ignored. 

If no `policy_id` is supplied, the module will attempt to create a new policy
with the name given in `policy_name`

To get the ID of the policy in the Organization (if any):
```bash
gcloud access-context-manager policies list --organization [orgid]
```

### Access Levels
Access levels are used for permitting access to resources based on contextual
information about the request. Using access levels, you can start to organize
tiers of trust.

Access Context Manager provides two ways to define access levels: basic and
custom.

A basic access level is a collection of conditions that are used to test
requests. Conditions are a group of attributes that you want to test, such as
device type, IP address, or user identity. The access level attributes represent
contextual information about a request.

Custom Access levels are not handled by this module.

### Regular Service Perimeter
A service perimeter creates a security boundary around Google Cloud resources.
You can configure a service perimeter to control communications from virtual
machines (VMs) to a Google Cloud service (API), and between Google Cloud
services. A service perimeter allows free communication within the perimeter
but, by default, blocks all communication across the perimeter.

For defining a regular use the variables:
- `live_run`
- `restricted_services`
- `resources` OR `resources_by_numbers`
- `access_levels`

`resources` lets you use project IDs will used Terraform `data` blocks to get
the project numbers. It will not work with projects do not exist or are create
as part of the same plan as in the Unit test. `resources` and
`resurces_by_numbers` are mutually exclusive.

For defining a dry-run to test out a perimeter without actually blocking use:
- `dry_run`
- `restricted_services_dry_run`
- `resources_dry_run` OR `resources_dry_run_by_numbers`
- `access_levels_dry_run`

`resources_dry_run` lets you use project IDs will used Terraform `data` blocks
to get the project numbers. It will not work with projects do not exist or are
create as part of the same plan as in the Unit test. `resources_dry_run` and
`resurces_dry_run_by_numbers` are mutually exclusive.

### Bridge Service Perimeter
A perimeter bridge allows projects in different security perimeters to
communicate. Perimeter bridges are bidirectional, allowing projects from each
service perimeter equal access within the scope of the bridge.

The variable `resources` lets you use project IDs will used Terraform `data`
blocks to get the project numbers. It will not work with projects do not exist
or are create as part of the same plan as in the Unit test. `resources` and
`resurces_by_numbers` are mutually exclusive.

## Unit testing
Secrets required for running unit test 

## Usage

See [examples](./examples)

### Github:
GOOGLE_APPLICATION_CREDENTIALS : JSON key of service account with permissions to
deploy to the Org/Folder SSH_KEY : Private RSA SSH key. Should belong to a
Github Service Account and not an individual UNITTEST_ACCESSLEVEL_MEMBERS : list
of Service Accounts, Groups or Users to add to the test access level.
- format [\"group:us@domain.ca\"] UNITTEST_BILLING_ACCOUNT : Billing account for
  test projects UNITTEST_ORG_ID : Organization ID for policy creation
  UNITTEST_POLICY_ID : Policy ID for existing policy (see above to gcloud
  command) UNITTEST_PROJECT_PARENT : Organization or Folder to place test
  projects into

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_level | map used to configure an access level | <pre>map(<br>    object({<br>      name                             = string<br>      combining_function               = optional(string)<br>      description                      = optional(string)<br>      ip_subnetworks                   = optional(list(string))<br>      required_access_levels           = optional(list(string))<br>      members                          = optional(list(string))<br>      regions                          = optional(list(string))<br>      negate                           = optional(bool)<br>      require_screen_lock              = optional(bool)<br>      require_corp_owned               = optional(bool)<br>      allowed_encryption_statuses      = optional(list(string))<br>      allowed_device_management_levels = optional(list(string))<br>      minimum_version                  = optional(string)<br>      os_type                          = optional(string)<br>    })<br>  )</pre> | `{}` | no |
| bridge\_service\_perimeter | map used to configure a bridge service perimeter | <pre>map(object({<br>    description          = optional(string)<br>    perimeter_name       = string<br>    resources            = optional(list(string))<br>    resources_by_numbers = optional(list(string))<br>    })<br>  )</pre> | `{}` | no |
| department\_code | Code for department, part of naming module | `string` | n/a | yes |
| environment | S-Sandbox P-Production Q-Quality D-development | `string` | n/a | yes |
| location | location for naming and resource placement | `string` | `"northamerica-northeast1"` | no |
| parent\_id | The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent. | `string` | n/a | yes |
| policy\_id | Policy ID is only used when a policy already exists | `string` | `null` | no |
| policy\_name | The policy's name, only used when creating a new policy | `string` | `"orgname-policy"` | no |
| regular\_service\_perimeter | map used to configure a regular service perimeter | <pre>map(object({<br>    description                  = optional(string)<br>    perimeter_name               = string<br>    restricted_services          = optional(list(string))<br>    resources                    = optional(list(string))<br>    resources_by_numbers         = optional(list(string))<br>    access_levels                = optional(list(string))<br>    restricted_services_dry_run  = optional(list(string))<br>    resources_dry_run            = optional(list(string))<br>    resources_dry_run_by_numbers = optional(list(string))<br>    access_levels_dry_run        = optional(list(string))<br>    vpc_accessible_services = optional(object({<br>      enable_restriction = bool,<br>      allowed_services   = list(string),<br>    }))<br>    dry_run  = optional(bool)<br>    live_run = optional(bool)<br>    })<br>  )</pre> | `{}` | no |
| user\_defined\_string | User defined string. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bridge\_service\_perimeter\_names | n/a |
| parent\_id | n/a |
| policy\_id | n/a |
| regular\_service\_perimeter\_names | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->