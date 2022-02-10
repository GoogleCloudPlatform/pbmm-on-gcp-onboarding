/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

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
