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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address"></a> [address](#input\_address) | The static IP address represented by this resource | `string` | `null` | no |
| <a name="input_address_type"></a> [address\_type](#input\_address\_type) | The type of address to reserve: INTERNAL or EXTERNAL | `string` | `"EXTERNAL"` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the address | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The network this address belongs to (only for INTERNAL) | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project where the address will be created | `string` | n/a | yes |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the resource (e.g., GCE\_ENDPOINT, VPC\_PEERING) | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the address will be created | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The subnetwork this address belongs to (only for INTERNAL) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | The IP address reserved |
| <a name="output_name"></a> [name](#output\_name) | The name of the address |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the created resource |
<!-- END_TF_DOCS -->
