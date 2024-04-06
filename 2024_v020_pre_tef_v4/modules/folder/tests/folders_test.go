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

import (
	"testing"

	"github.com/Jeffail/gabs/v2"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModuleDeployment(t *testing.T) {
	t.Parallel()
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	validateOutputs(t, terraformOptions)
}

func validateOutputs(t *testing.T, opts *terraform.Options) {
	jsonParsed, err := gabs.ParseJSON([]byte(terraform.OutputJson(t, opts, "")))

	names := map[string]string{
		"Audit":          "Audit",
		"NonProduction":  "NonProduction",
		"Production":     "Production",
		"Platform":		  "Platform",
	}

	if err != nil {
		panic(err)
	}

	audit, _ := jsonParsed.JSONPointer("/names/value/Audit")
	assert.Contains(t, audit.Data().(string), names["Audit"])
	nonProduction, _ := jsonParsed.JSONPointer("/names/value/NonProduction")
	assert.Contains(t, nonProduction.Data().(string), names["NonProduction"])
	production, _ := jsonParsed.JSONPointer("/names/value/Production")
	assert.Contains(t, production.Data().(string), names["Production"])
	platform, _ := jsonParsed.JSONPointer("/names/value/Platform")
	assert.Contains(t, platform.Data().(string), names["Platform"])
}
