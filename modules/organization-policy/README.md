# terraform-organization-policy

As part of the GCP landing zone, GCP organization policy constraints will be
utilized as a preventative guardrail to protect the platform.

The initial set of policies constraints that will be enabled by default are
aligned with the recommendation in the GCP COM LZ Design Recommendation,
including these following policies.

## Default GCP Organizational Policy constraints

1. GCP Resource Location Restriction - Restrict all United States, Asia, Europe,
   and South America location

1. Virtual Machine instances will not be allowed Public IPs

1. Only GC organization's customer directory ID will be allowed as IAM entity in
   GCP, this will block all other GSuite organization, including Gmail accounts.


1. Enforce Uniform bucket-level IAM Access and management

1. Requires OS login for any SSH/RDP needs

1. Skip default VPC Creation when new project is created

1. Restrict VM IP Forwarding

## Module Input

### Required Input
The module has required inputs of
```
organization_id : String
    GCP organization ID that the policy constraints will be applied on
```
```
directory_customer_id : list of string
    GSuite directory customer ID used for IAM domain restriction. This can be retrieved by running *Gcloud organizations list* after you have authenticated with GCloud.
    To get the ID use `gcloud organizations list` this is the last field, not the numbered field.
    Format for Github secret [\"ID\"]
```
Both of these two inputs will be required when using the module. 

### Optional Inputs

Optional inputs can be made to add additional organization policy constraints,
as shown below, using the *policy_boolean* and *policy_list* variable.

```
module "org_policy" {
  policy_boolean = {
    "constraints/compute.disableGuestAttributesAccess" = true
    "constraints/compute.skipDefaultNetworkCreation" = true
  }
  policy_list = {
    "constraints/computetrustedImageProjects" = {
      inherit_from_parent = null
      suggested_value = null
      status = true
      values = ["projects/my-project"]
    }
  }
}
```

## Policies Exclusion

GCP provides capabilities for excluding certain policy constraints. For the LZ
platform, exclusion will be applied via the Project Module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| directory\_customer\_id | GCP organization directory customer id | `list(string)` | n/a | yes |
| organization\_id | ID of GCP organization | `string` | n/a | yes |
| policy\_boolean | Map of boolean org policies and enforcement value, set value to null for policy restore. | `map(bool)` | `{}` | no |
| policy\_list | Map of list org policies, status is true for allow, false for deny, null for restore. Values can only be used for allow or deny. | <pre>map(object({<br>    inherit_from_parent = bool<br>    suggested_value     = string<br>    status              = bool<br>    values              = list(string)<br>  }))</pre> | `{}` | no |
| set\_default\_policy | A flag if true, then enable default policy, else set no default policy | `bool` | `true` | no |
| vms\_allowed\_with\_external\_ip | Allowed list of VMs full URI that can have external ID | `list(string)` | `[]` | no |
| vms\_allowed\_with\_ip\_forward | Allowed list of VMs full URI that can have external ID | `list(string)` | `[]` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->