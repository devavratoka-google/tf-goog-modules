# Global Addresses Module

This module creates a Google Cloud Compute Global Address.

## Usage

```hcl
module "global_addresses" {
  source      = "./modules/global_addresses"
  name        = "my-global-address"
  description = "My global address for VPC peering"
  labels      = { environment = "production" }
  ip_version  = "IPV4"
  project     = "my-project-id"
  network     = "my-vpc-self-link"
  address     = "10.0.0.0"
  prefix_length = 16
  purpose     = "VPC_PEERING"
  address_type = "INTERNAL"
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
| [google_compute_global_address.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address"></a> [address](#input\_address) | The IP address or beginning of the address range represented by this resource. This can be supplied as an input to reserve a specific address or omitted to allow GCP to choose a valid one for you. | `string` | n/a | yes |
| <a name="input_address_type"></a> [address\_type](#input\_address\_type) | The type of the address to reserve. Default value is EXTERNAL. Possible values are: EXTERNAL, INTERNAL. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. | `string` | n/a | yes |
| <a name="input_ip_version"></a> [ip\_version](#input\_ip\_version) | The IP Version that will be used by this address. The default value is IPV4. Possible values are: IPV4, IPV6. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels | `map(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The URL of the network in which to reserve the IP range. The IP range must be in RFC1918 space. The network cannot be deleted if there are any reserved IP ranges referring to it. This should only be set when using an Internal address. | `string` | n/a | yes |
| <a name="input_prefix_length"></a> [prefix\_length](#input\_prefix\_length) | The prefix length of the IP range. If not present, it means the address field is a single IP address. This field is not applicable to addresses with addressType=INTERNAL when purpose=PRIVATE\_SERVICE\_CONNECT | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the resource. Possible values include: VPC\_PEERING or PRIVATE\_SERVICE\_CONNECT | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | The reserved global IP address. |
| <a name="output_global_address_name"></a> [global\_address\_name](#output\_global\_address\_name) | The name of the reserved global IP address. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the reserved global IP address. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the reserved global IP address. |
<!-- END_TF_DOCS -->
