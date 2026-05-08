# NCC Hub Module

This module creates a Google Cloud Network Connectivity Center (NCC) Hub and associated groups.

## Usage

```hcl
module "ncc_hub" {
  source      = "./modules/ncc_hub"
  name        = "my-hub"
  description = "My NCC Hub"
  # ... other required variables
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Immutable. The name of the hub | `string` | n/a | yes |
| description | An optional description of the hub | `string` | n/a | yes |
| labels | Optional labels in key:value format | `map(string)` | n/a | yes |
| preset_topology | The topology implemented in this hub | `string` | n/a | yes |
| export_psc | Whether Private Service Connect transitivity is enabled | `bool` | n/a | yes |
| project | The ID of the project in which the resource belongs | `string` | n/a | yes |
| ncc_groups | A map of NCC groups to create | `map(object)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ncc_hub_id | The ID of the hub |
