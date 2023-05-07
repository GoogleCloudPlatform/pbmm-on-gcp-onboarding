// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.



package tests

type testCaseMapType map[string][]map[string]map[string]string
type resourceNameTests []map[string]map[string]string
type nameTest map[string]map[string]string

type arguments map[string]string
type runTests map[string]string

// NOTE: The 'key name' must match the 'directory name' under the './examples' folder
// commonArgsMap found in common_args.go file.
// Add test cases to this map for terratests
var testCaseMap = testCaseMapType{
	// generic resource name
	"generic_resource_name": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"resource_type":       "gen",
				"device_type":         "ADC",
				"user_defined_string": "Core-Security",
			},
			"tests": runTests{
				"equal": "LzPeADC-Core-Security-gen",
			},
		},
	},
	// folder
	"folder": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"owner":   "PBMM",
				"project": "root proj",
			},
			"tests": runTests{
				"equal": "LzPe-PBMM-root proj",
			},
		},
		// test for no naming updates
		nameTest{
			"args": arguments{
				"project": "root proj",
			},
			"tests": runTests{
				"equal": "root proj",
			},
		},
		// test for no owner
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"project": "root proj",
			},
			"tests": runTests{
				"equal": "LzPe-root proj",
			},
		},
	},
	// project
	"project": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"owner":                          "PBMM",
				"user_defined_string":            "uds test",
				"additional_user_defined_string": "prj uds test",
			},
			"tests": runTests{
				"equal": "LzPe-PBMM-uds test-prj uds test",
			},
		},
		nameTest{
			"common_args": commonArgsMap["ScDe"],
			"args": arguments{
				"owner":                          "PBMM",
				"user_defined_string":            "uds test",
				"additional_user_defined_string": "prj uds test",
			},
			"tests": runTests{
				"equal": "ScDe-PBMM-uds test-prj uds test",
			},
		},
	},

	// networking - virtual_network
	"virtual_private_cloud": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["ScPe"],
			"args": arguments{
				"user_defined_string": "prod-paz",
			},
			"tests": runTests{
				"equal":    "scpecnr-prod-paz-vpc",
				"notequal": "ScPeCNR-prod-paz-vpc",
			},
		},
	},
	"subnet": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["ScPe"],
			"args": arguments{
				"user_defined_string":            "mrz",
				"additional_user_defined_string": "sec",
			},
			"tests": runTests{
				"equal":    "scpecnr-mrz-sec-snet",
				"notequal": "ScPeCNR-MRZ-SEC-snet",
			},
		},
	},
	"route": resourceNameTests{
		nameTest{
			"args": arguments{
				"user_defined_string": "toCoreLB_Transit_Internet",
			},
			"tests": runTests{
				"equal": "toCoreLB_Transit_Internet-route",
			},
		},
	},
	"router": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "egress",
			},
			"tests": runTests{
				"equal":    "lzpecnr-egress-router",
				"notequal": "LzPeCNR-egress-router",
			},
		},
	},
	"nat": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "shared-ngw",
			},
			"tests": runTests{
				"equal":    "lzpecnr-shared-ngw-nat",
				"notequal": "LzPeCNR-shared-ngw-nat",
			},
		},
	},
	"firewall_rule": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["ScPe"],
			"args": arguments{
				"user_defined_string": "allow-rdp",
			},
			"tests": runTests{
				"equal":    "scpefwl-allow-rdp-fwr",
				"notequal": "ScPeFWL-allow-rdp-fwr",
			},
		},
	},

	"storage": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "aksn4isnxldhslrenshw",
			},
			"tests": runTests{
				"equal":    "lzpeaksn4isnxldhslrenshw",
				"notequal": "LzPeaksn4isnxldhslrenshw",
			},
		},
	},

	"service_account": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "aksn4isnxldhslren",
			},
			"tests": runTests{
				"equal":    "lzpecld-aksn4isnxldhslren-sa",
				"notequal": "LzPeCLD-aksn4isnxldhslren-sa",
			},
		},
	},

	"cloud_function": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "Prod",
				"additional_user_defined_string": "Scan",
			},
			"tests": runTests{
				"equal":    "LzPeCPS-Prod-Scan-cf",
			},
		},
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "ProdScan",
			},
			"tests": runTests{
				"equal": "LzPeCPS-ProdScan-cf",
			},
		},
	},

	"cloud_scheduler_job": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "guardrail",
			},
			"tests": runTests{
				"equal": "LzPeCPS-guardrail-csj",
			},
		},
	},

	"cloudbuild_trigger": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["ScPe"],
			"args": arguments{
				"user_defined_string": "generatereport",
			},
			"tests": runTests{
				"equal": "ScPeCPS-generatereport-cbt",
			},
		},
	},

	"container_registry_image": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["ScPe"],
			"args": arguments{
				"user_defined_string": "guardrails-policies",
			},
			"tests": runTests{
				"equal": "scpeccr-guardrails-policies-cntr",
				"notequal": "ScPeCCR-guardrails-policies-cntr",
			},
		},
	},

	"vpc_svc_ctl": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["ScPe"],
			"args": arguments{
				"user_defined_string": "example",
			},
			"tests": runTests{
				"equal": "scpevsc_example_vsc",
			},
		},
	},

	"custom_role": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["ScPe"],
			"args": arguments{
				"user_defined_string": "example",
			},
			"tests": runTests{
				"equal": "ScPeROL_example_role",
			},
		},
	},

	// Log Analytics
	"log_sink": resourceNameTests{
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "CoreSecurity",
			},
			"tests": runTests{
				"equal": "LzPeCLD-CoreSecurity-sink",
			},
		},
		nameTest{
			"common_args": commonArgsMap["LzPe"],
			"args": arguments{
				"user_defined_string": "Core-Security-Logs",
			},
			"tests": runTests{
				"equal": "LzPeCLD-Core-Security-Logs-sink",
			},
		},
	},
}
