# Private Service Access (PSA) Module

This module creates a GCP Service Networking Connection to enable Private Service Access (PSA) with Google service producers, and configures the connection to import and export custom routes.

## Usage

```hcl
module "private_service_access" {
  source                  = "./modules/psa"
  network                 = "my-vpc-self-link"
  reserved_peering_ranges = ["my-reserved-peering-range-name"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.0.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network_peering_routes_config.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering_routes_config) | resource |
| [google_service_networking_connection.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network"></a> [network](#input\_network) | (Required) Name of VPC network connected with service producers using VPC peering. | `string` | n/a | yes |
| <a name="input_reserved_peering_ranges"></a> [reserved\_peering\_ranges](#input\_reserved\_peering\_ranges) | (Required) Named IP address range(s) of PEERING type reserved for this service provider. Note that invoking this method with a different range when connection is already established will not reallocate already provisioned service producer subnetworks. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the service networking connection. |
| <a name="output_peering"></a> [peering](#output\_peering) | The name of the VPC peering connection created. |
<!-- END_TF_DOCS -->
