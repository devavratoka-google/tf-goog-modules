# VPC Module

This module creates a Google Cloud Virtual Private Cloud (VPC) network.

## Usage

```hcl
module "vpc" {
  source       = "./modules/vpc"
  project_id   = "my-project-id"
  network_name = "my-vpc"
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
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_network.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| <a name="input_bgp_always_compare_med"></a> [bgp\_always\_compare\_med](#input\_bgp\_always\_compare\_med) | If set to true, the Cloud Router will use MED values from the peer even if the AS paths differ. Default is false. | `bool` | `false` | no |
| <a name="input_bgp_best_path_selection_mode"></a> [bgp\_best\_path\_selection\_mode](#input\_bgp\_best\_path\_selection\_mode) | Specifies the BGP best path selection mode. Valid values are `STANDARD` or `LEGACY`. Default is `LEGACY`. | `string` | `"LEGACY"` | no |
| <a name="input_bgp_inter_region_cost"></a> [bgp\_inter\_region\_cost](#input\_bgp\_inter\_region\_cost) | Specifies the BGP inter-region cost mode. Valid values are `DEFAULT` or `ADD_COST_TO_MED`. | `string` | `null` | no |
| <a name="input_delete_default_internet_gateway_routes"></a> [delete\_default\_internet\_gateway\_routes](#input\_delete\_default\_internet\_gateway\_routes) | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `""` | no |
| <a name="input_enable_ipv6_ula"></a> [enable\_ipv6\_ula](#input\_enable\_ipv6\_ula) | Enabled IPv6 ULA, this is a permanent change and cannot be undone! (default 'false') | `bool` | `false` | no |
| <a name="input_internal_ipv6_range"></a> [internal\_ipv6\_range](#input\_internal\_ipv6\_range) | When enabling IPv6 ULA, optionally, specify a /48 from fd20::/20 (default null) | `string` | `null` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively. | `number` | `0` | no |
| <a name="input_network_firewall_policy_enforcement_order"></a> [network\_firewall\_policy\_enforcement\_order](#input\_network\_firewall\_policy\_enforcement\_order) | Set the order that Firewall Rules and Firewall Policies are evaluated. Valid values are `BEFORE_CLASSIC_FIREWALL` and `AFTER_CLASSIC_FIREWALL`. (default null or equivalent to `AFTER_CLASSIC_FIREWALL`) | `string` | `null` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network being created | `string` | n/a | yes |
| <a name="input_network_profile"></a> [network\_profile](#input\_network\_profile) | "A full or partial URL of the network profile to apply to this network.<br/>This field can be set only at resource creation time. For example, the<br/>following are valid URLs:<br/>  * https://www.googleapis.com/compute/beta/projects/{projectId}/global/networkProfiles/{network_profile_name}<br/>  * projects/{projectId}/global/networkProfiles/{network\_profile\_name} | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project where this VPC will be created | `string` | n/a | yes |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | The VPC resource being created |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | The ID of the VPC being created |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_project"></a> [network\_project](#output\_network\_project) | The project of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
<!-- END_TF_DOCS -->
