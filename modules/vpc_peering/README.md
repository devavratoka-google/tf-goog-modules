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

## Requirements

| Name | Version |
|------|---------|
| terraform | > 1.5.0 |
| google | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| local_network_peering_name | Name of the local network peering connection. | `string` | n/a | yes |
| peer_network_peering_name | Name of the peer network peering connection. | `string` | n/a | yes |
| local_network | URL/Self Link of the local VPC network. | `string` | n/a | yes |
| peer_network | URL/Self Link of the peer VPC network. | `string` | n/a | yes |
| export_local_custom_routes | Whether to export custom routes from the local network to the peer network. | `bool` | n/a | yes |
| export_peer_custom_routes | Whether to export custom routes from the peer network to the local network. | `bool` | n/a | yes |
| export_local_subnet_routes_with_public_ip | Whether subnet routes with public IP range are exported from the local network. | `bool` | n/a | yes |
| export_peer_subnet_routes_with_public_ip | Whether subnet routes with public IP range are imported from the peer network. | `bool` | n/a | yes |
| stack_type | Which IP version(s) of traffic and routes are allowed to be imported or exported between peer networks. Possible values: `IPV4_ONLY`, `IPV4_IPV6`. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| local_peering_state | The state of the local peering resource |
