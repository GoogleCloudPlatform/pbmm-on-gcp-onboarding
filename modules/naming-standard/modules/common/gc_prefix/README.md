# Overview
This module generates the GC prefix naming for GCP resource naming.

# Limitations

# Known Issues

# Usage
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| department\_code | Two character department code. Format: Uppercase lowercase e.g. Sc. | `string` | n/a | yes |
| environment | Single character environment code. Valid values: P = Production, D = Development, Q = Quality Assurance, S = Sandbox | `string` | n/a | yes |
| location | CSP and Region. Valid values: northamerica-northeast1. Code will be used for naming | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| csp\_region\_code | n/a |
| gc\_governance\_prefix | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
