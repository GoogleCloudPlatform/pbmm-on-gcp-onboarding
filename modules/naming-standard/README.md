# Overview

Source the module from `modules/gcp/<module_name>` to get the required naming convention for the resource.

# Limitations

# Known Issues

# Example Usage
```hcl
locals {
   ca_governance = {
    department_code = var.department_code
    environment     = var.environment
    location      = var.location
  }
}

# folders
module "folder_name" {
  source        = "../naming-standard//modules/gcp/google_folder
  ca_governance = local.ca_governance
  owner         = var.owner
  project       = var.project
}

resource "google_folder" "audit" {
  display_name = module.folder_name.result
}
```

# Development

To add resources, create the resource folder under `modules/gcp/<resource_name>`. The `resource_name`
will need to be aligned with the test cases in [gc_name_tests.go](./tests/gc_name_tests.go).
1. Add a `README.md` file.
1. Based on the type of resource, you will need to select a "common" template. In the folder
   `modules/common/module`, there are a few templates that can be used. To reduce duplication, the
   use of symlink is recommended. For example, from your module folder, `ln -s ../../common/module/common.tf common.tf`. To help determine the template to use, refer to this
   [README](./modules/common/module/README.md) between resources.
1. Add a `variables.tf` and edit the file with the required arguments and update the locals variable
   inside with the correct _type_ code and _name_sections_ map, which are arguments passed into
   `modules/common/name_generator`
1. Add the resource code into `configs/resource_naming_patterns.yaml` and create a Terrform template
   string for the naming pattern, the code can be taken from `config/resource_types.yaml`
1. Add template variables to the _data_ _template_file_ in `modules/common/name_generator/main.tf`

## Dev Tip
The best workflow for TDD when adding new resource naming patterns so far. To ease the effort, have the following files open in this order:
- [configs/resource_types.yaml](./configs/resource_types.yaml)
- [configs/resource_naming_patterns.yaml](./configs/resource_naming_patterns.yaml)
- [tests/gc_name_tests.go](./tests/gc_name_tests.go)
- [modules/common/name_generator/variables.tf](./modules/common/name_generator/variables.tf)
- [modules/common/name_generator/main.tf](./modules/common/name_generator/main.tf)


1. Create naming pattern in `configs/resource_naming_patterns.yaml`. For each top-level type such as `vnet`, `compute_vm`, you can define resource naming templates to reduce duplication. This is done by creating an array named `common_prefixes`. The patterns in this array are then reference using the `common_prefix_index`. The numbering is zero based indexed. Example:
```yaml
  compute_vm:
    common_prefixes:
      - '${gc_governance_prefix}${device_type}-${user_defined_string}'      # Index 0
      - '${parent_resource}'                                                # Index 1
    # <dept code><environment><CSP Region><device type>-<User Defined_String>##
    # Note: Suffix is not used on Virtual Machines
    vm:
      commmon_prefix_index: 0             # This retrieves compute_vm.common_prefixes[0] --> '${gc_governance_prefix}${device_type}-${user_defined_string}'
      # Combining the prefix and suffix template, the template now becomes: ''${gc_governance_prefix}${device_type}-${user_defined_string}'${number_suffix}'
      suffix_template: '${number_suffix}'
```
3. Add resource type code to `type` variable validation in `modules/common/name_generator/variables.tf` and parent code, if necessary.
1. Double-check `modules/common/name_generator/main.tf` `data "template_file" "gc_name"` to see if any new variables need to be added to the template.
1. Create resource in `modules/gcp/<resource_name>`, and edit README.md and variables, as needed.
1. Create symlink to the required `common*.tf` in `modules/common/module/*` in `modules/gcp/<resource_name>`
1. Update tests and run. See next section.

# Testing
Add new terratest in `tests/gc_name_tests.go`.

Each resource needs its own `resourceNameTests` map. If you have multiple test cases for a resource
type, you can add multiple `nameTest`. See excerpt below:
```go
	"subnet": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["ScPc"],
			"args": arguments{
				"user_defined_string":            "MRZ",
				"additional_user_defined_string": "SEC",
			},
			"tests": runTests{
				"equal": "ScPcCNR-MRZ-SEC-snet",
			},
		},
		nameTest{
			"common_args": commonArgsMap["ScPc"],
			"args": arguments{
				"user_defined_string":            "MRZ",
				"additional_user_defined_string": "AzureBastionSubnet",
			},
			"tests": runTests{
				"equal": "AzureBastionSubnet",
			},
		},
		nameTest{
			"common_args": commonArgsMap["ScPc"],
			"args": arguments{
				"user_defined_string":            "MRZ",
				"additional_user_defined_string": "AzureFirewallSubnet",
			},
			"tests": runTests{
				"equal": "AzureFirewallSubnet",
			},
		},
		nameTest{
			"common_args": commonArgsMap["ScPc"],
			"args": arguments{
				"user_defined_string":            "MRZ",
				"additional_user_defined_string": "GatewaySubnet",
			},
			"tests": runTests{
				"equal": "GatewaySubnet",
			},
		},
	},
```
To help with testing, a few `common_args` are available for use in `tests/common_args.go`. These objects
provide sufficient coverage across regions and service tiers.

Resource types that are sub-resources do not use a `common_args`. Instead, they have a parent
resource name that will be used to generate the prefix. Example:
```go
	"public_ip": resourceNameTests{
		nameTest{
			"args": arguments{
				"parent_resource": "ScPcFWL-egress_fw-egress_fw",
			},
			"tests": runTests{
				"equal": "ScPcFWL-egress_fw-egress_fw-pip1",
			},
		},
  },
```
