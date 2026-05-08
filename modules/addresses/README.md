# Addresses Module

This module creates a Google Cloud Compute Address (static IP).

## Usage

```hcl
module "addresses" {
  source  = "./modules/addresses"
  project = "my-project-id"
  name    = "my-address"
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
| project | The ID of the project where the address will be created | `string` | n/a | yes |
| name | The name of the address | `string` | n/a | yes |
| description | An optional description of this resource | `string` | `null` | no |
| address | The static IP address represented by this resource | `string` | `null` | no |
| address_type | The type of address to reserve: INTERNAL or EXTERNAL | `string` | `"EXTERNAL"` | no |
| purpose | The purpose of the resource | `string` | `null` | no |
| network | The network this address belongs to | `string` | `null` | no |
| subnetwork | The subnetwork this address belongs to | `string` | `null` | no |
| region | The region where the address will be created | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| address | The IP address reserved |
| name | The name of the address |
| self_link | The URI of the created resource |
