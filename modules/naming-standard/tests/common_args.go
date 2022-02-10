/**
 * Copyright 2019 Google LLC
 *
 * Copyright 2021 Google LLC. This software is provided as is, without
 * warranty or representation for any use or purpose. Your use of it is
 * subject to your agreement with Google.
*/

package tests

type commonArgsMapType map[string]map[string]string
type commonArgsType map[string]string

var commonArgsMap = commonArgsMapType{
	"LzPe": commonArgsType{
		"department_code": "Lz",
		"environment":     "P",
		"location":        "northamerica-northeast1",
	},
	"ScDe": commonArgsType{
		"department_code": "Sc",
		"environment":     "D",
		"location":        "northamerica-northeast1",
	},
	"ScPe": commonArgsType{
		"department_code": "Sc",
		"environment":     "P",
		"location":        "northamerica-northeast1",
	},
}
