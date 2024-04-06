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
	"errors"
	"fmt"
	"os"
	"reflect"
	"strconv"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestNames(t *testing.T) {
	t.Parallel()

	// Set comma separated list in env variable to target specific tests to run vs running all tests.
	envTargetTestRun := os.Getenv("TERRATESTS_TESTNAMES_LIST")
	var targetTests []string
	if envTargetTestRun != "" {
		targetTests = strings.Split(envTargetTestRun, ",")
		fmt.Println("Testing:", targetTests)
	}

	for resource, tests := range testCaseMap {
		_, found := Find(targetTests, resource)
		if len(targetTests) > 0 && found {
			// run specific tests
			runTestName(t, resource, tests)
		} else if len(targetTests) == 0 {
			// run all tests
			runTestName(t, resource, tests)
		}
	}
}

func runTestName(t *testing.T, resource string, tests resourceNameTests) {
	fmt.Println("Key:", resource, "=>", "Element:", tests)
	fmt.Println("-------------------- TEST ---------------:" + resource)
	for _, value := range tests {
		fmt.Println(value["args"])

		// merge common_args + args
		for k, v := range value["common_args"] {
			value["args"][k] = v
		}
		// convert
		vars := make(map[string]interface{}, len(value["args"]))
		for i, v := range value["args"] {
			vars[i] = v
		}
		fmt.Println(vars)

		// setup dir / vars
		opts := &terraform.Options{
			TerraformDir: "../modules/gcp/" + resource,
			Vars:         vars,
		}
		defer terraform.Destroy(t, opts)
		terraform.InitAndApply(t, opts)

		actualName := terraform.Output(t, opts, "result")

		// run tests
		for test, expectedVal := range value["tests"] {
			Call(functions, test, t, expectedVal, actualName)
		}
	}
}

// Find takes a slice and looks for an element in it. If found it will
// return it's key, otherwise it will return -1 and a bool of false.
func Find(slice []string, val string) (int, bool) {
	for i, item := range slice {
		if item == val {
			return i, true
		}
	}
	return -1, false
}

// Reflect to call functions
func Call(functionsMap map[string]interface{}, name string, params ...interface{}) (result []reflect.Value, err error) {
	f := reflect.ValueOf(functionsMap[name])
	if len(params) != f.Type().NumIn() {
		err = errors.New("the number of params is not adapted")
		return
	}
	in := make([]reflect.Value, len(params))
	for k, param := range params {
		in[k] = reflect.ValueOf(param)
	}
	result = f.Call(in)
	return
}

type funcMapType map[string]interface{}

// Add test functions
var functions = funcMapType{
	"equal":    testEqual,
	"notequal": testNotEqual,
	"contains": testContains,
	"length":   testLength,
}

// Assert functions
func testEqual(t *testing.T, expected string, actual string) {
	fmt.Println(" ========= Test Equals ==== Expected: " + expected + " Actual: " + actual)
	assert.Equal(t, expected, actual)
}

func testNotEqual(t *testing.T, expected string, actual string) {
	fmt.Println(" ========= Test Not Equals ==== Expected: " + expected + " not equal Actual: " + actual)
	assert.NotEqual(t, expected, actual)
}

func testContains(t *testing.T, contains string, actual string) {
	fmt.Println(" ========= Test Contains ==== Actual: " + actual + " Contains: " + contains)
	assert.Contains(t, actual, contains)
}

func testLength(t *testing.T, expectedLen string, actual string) {
	lenActual := len(actual)
	lenExpected, err := strconv.Atoi(expectedLen)

	if err == nil {
		fmt.Printf(" ========= Test Length ==== Expected: %d Actual: %d\n", lenExpected, lenActual)

		assert.Equal(t, lenExpected, lenActual)
	}
}
