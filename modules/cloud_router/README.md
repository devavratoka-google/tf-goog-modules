# Cloud Router Module

This module creates a Google Cloud Compute Router, including interfaces and BGP peers.

## Usage

```hcl
module "cloud_router" {
  source  = "./modules/cloud_router"
  name    = "my-router"
  network = "my-vpc-self-link"
  asn     = 64514
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
| name | Name of the resource | `string` | n/a | yes |
| network | A reference to the network to which this router belongs | `string` | n/a | yes |
| description | An optional description of this resource | `string` | n/a | yes |
| asn | Local BGP Autonomous System Number (ASN) | `number` | n/a | yes |
| advertise_mode | Mode to use for advertisement | `string` | n/a | yes |
| advertised_groups | List of prefix groups to advertise | `list(string)` | n/a | yes |
| advertised_ip_ranges | List of individual IP ranges to advertise | `map(object)` | n/a | yes |
| keepalive_interval | Interval in seconds between BGP keepalive messages | `number` | n/a | yes |
| identifier_range | Specifies a range of valid BGP Identifiers | `string` | n/a | yes |
| encrypted_interconnect_router | Indicates if dedicated for use with encrypted VLAN attachments | `bool` | n/a | yes |
| region | Region where the router resides | `string` | n/a | yes |
| project | The ID of the project in which the resource belongs | `string` | n/a | yes |
| router_interfaces | Map of object for Cloud Router Interfaces | `map(object)` | n/a | yes |
| router_peers | Map of object for Cloud Router Peers | `map(object)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| router_name | The name of the router |
| router_link | The self link of the router |
| router_project | The project of the router |
| router_region | The region of the router |
