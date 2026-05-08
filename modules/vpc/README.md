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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 7.0.0 |
| google-beta | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| google-beta | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The ID of the project where this VPC will be created | `string` | n/a | yes |
| network_name | The name of the network being created | `string` | n/a | yes |
| routing_mode | The network routing mode | `string` | `"GLOBAL"` | no |
| description | An optional description of this resource | `string` | `""` | no |
| auto_create_subnetworks | When set to true, the network is created in 'auto subnet mode' | `bool` | `false` | no |
| delete_default_internet_gateway_routes | If set, delete default routes | `bool` | `false` | no |
| mtu | The network MTU | `number` | `0` | no |
| enable_ipv6_ula | Enabled IPv6 ULA | `bool` | `false` | no |
| internal_ipv6_range | When enabling IPv6 ULA, optionally, specify a /48 | `string` | `null` | no |
| network_firewall_policy_enforcement_order | Set the order that Firewall Rules and Firewall Policies are evaluated | `string` | `null` | no |
| network_profile | A full or partial URL of the network profile | `string` | `null` | no |
| bgp_always_compare_med | If set to true, Cloud Router will use MED values | `bool` | `false` | no |
| bgp_best_path_selection_mode | Specifies the BGP best path selection mode | `string` | `"LEGACY"` | no |
| bgp_inter_region_cost | Specifies the BGP inter-region cost mode | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| network | The VPC resource being created |
| network_name | The name of the VPC being created |
| network_id | The ID of the VPC being created |
| network_self_link | The URI of the VPC being created |
| network_project | The project of the VPC being created |
