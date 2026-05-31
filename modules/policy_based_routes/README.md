# Policy Based Routes Module

This module appears to be empty or a placeholder.

## Usage

This module does not currently contain any resources or variables.

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
| [google_network_connectivity_policy_based_route.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_policy_based_route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dest_range"></a> [dest\_range](#input\_dest\_range) | The destination range of this policy based route. | `string` | n/a | yes |
| <a name="input_ip_protocol"></a> [ip\_protocol](#input\_ip\_protocol) | The IP protocol of this policy based route. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the policy based route. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The network to which this policy based route belongs. | `string` | n/a | yes |
| <a name="input_next_hop_ilb_ip"></a> [next\_hop\_ilb\_ip](#input\_next\_hop\_ilb\_ip) | The IP address of the internal load balancer to which this policy based route will forward traffic. | `string` | n/a | yes |
| <a name="input_next_hop_other_routes"></a> [next\_hop\_other\_routes](#input\_next\_hop\_other\_routes) | The list of other routes to which this policy based route will forward traffic. | `string` | n/a | yes |
| <a name="input_priority"></a> [priority](#input\_priority) | The priority of this policy based route. | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project to which this policy based route belongs. | `string` | n/a | yes |
| <a name="input_protocol_version"></a> [protocol\_version](#input\_protocol\_version) | The protocol version of this policy based route. | `string` | n/a | yes |
| <a name="input_src_range"></a> [src\_range](#input\_src\_range) | The source range of this policy based route. | `string` | n/a | yes |
| <a name="input_virtual_machine_tags"></a> [virtual\_machine\_tags](#input\_virtual\_machine\_tags) | The list of tags that will be applied to the virtual machines that match this policy based route. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
