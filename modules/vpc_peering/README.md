# VPC Peering Module

This module establishes a bi-directional VPC network peering connection between a local network and a peer network.

## Usage

```hcl
module "vpc_peering" {
  source                     = "./modules/vpc_peering"
  local_network_peering_name = "peering-local-to-peer"
  peer_network_peering_name  = "peering-peer-to-local"
  local_network              = "local-vpc-self-link"
  peer_network               = "peer-vpc-self-link"
  
  export_local_custom_routes = true
  export_peer_custom_routes  = true
  
  export_local_subnet_routes_with_public_ip = true
  export_peer_subnet_routes_with_public_ip  = false
  
  stack_type = "IPV4_ONLY"
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
| [google_compute_network_peering.local_network_peering](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering) | resource |
| [google_compute_network_peering.peer_network_peering](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_export_local_custom_routes"></a> [export\_local\_custom\_routes](#input\_export\_local\_custom\_routes) | Whether to export the custom routes to the peer network. Defaults to false. | `bool` | n/a | yes |
| <a name="input_export_local_subnet_routes_with_public_ip"></a> [export\_local\_subnet\_routes\_with\_public\_ip](#input\_export\_local\_subnet\_routes\_with\_public\_ip) | Whether subnet routes with public IP range are exported. The default value is true, all subnet routes are exported. | `bool` | n/a | yes |
| <a name="input_export_peer_custom_routes"></a> [export\_peer\_custom\_routes](#input\_export\_peer\_custom\_routes) | Whether to export the custom routes from the peer network. Defaults to false. | `bool` | n/a | yes |
| <a name="input_export_peer_subnet_routes_with_public_ip"></a> [export\_peer\_subnet\_routes\_with\_public\_ip](#input\_export\_peer\_subnet\_routes\_with\_public\_ip) | Whether subnet routes with public IP range are imported. The default value is false. | `bool` | n/a | yes |
| <a name="input_local_network"></a> [local\_network](#input\_local\_network) | The primary network of the peering. | `string` | n/a | yes |
| <a name="input_local_network_peering_name"></a> [local\_network\_peering\_name](#input\_local\_network\_peering\_name) | Name of the local peering. | `string` | n/a | yes |
| <a name="input_peer_network"></a> [peer\_network](#input\_peer\_network) | The peer network in the peering. The peer network may belong to a different project. | `string` | n/a | yes |
| <a name="input_peer_network_peering_name"></a> [peer\_network\_peering\_name](#input\_peer\_network\_peering\_name) | Name of the peer peering. | `string` | n/a | yes |
| <a name="input_stack_type"></a> [stack\_type](#input\_stack\_type) | Which IP version(s) of traffic and routes are allowed to be imported or exported between peer networks. The default value is IPV4\_ONLY. Possible values: ['IPV4\_ONLY', 'IPV4\_IPV6']. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_local_peering_id"></a> [local\_peering\_id](#output\_local\_peering\_id) | The ID of the local VPC peering connection. |
| <a name="output_local_peering_state"></a> [local\_peering\_state](#output\_local\_peering\_state) | The state of the local VPC peering connection. |
| <a name="output_peer_peering_id"></a> [peer\_peering\_id](#output\_peer\_peering\_id) | The ID of the peer VPC peering connection. |
| <a name="output_peer_peering_state"></a> [peer\_peering\_state](#output\_peer\_peering\_state) | The state of the peer VPC peering connection. |
<!-- END_TF_DOCS -->
