# Network Connectivity Center (NCC) Spoke Module

This module creates a Network Connectivity Center (NCC) Spoke resource, attaching various hybrid connectivity or VPC networking resources to an NCC Hub.

## Usage

```hcl
module "ncc_spoke" {
  source      = "./modules/ncc_spoke"
  name        = "my-vpc-spoke"
  hub         = "my-hub-uri"
  location    = "global"
  description = "Spoke connecting my-vpc to the Hub"
  project     = "my-project-id"
  group       = "default"
  labels      = { env = "prod" }

  linked_vpc_network = {
    "my-vpc" = {
      uri                   = "my-vpc-self-link"
      exclude_export_ranges = []
      include_export_ranges = []
    }
  }

  linked_interconnect_attachments   = {}
  linked_vpn_tunnels                = {}
  linked_producer_vpc_network       = {}
  linked_router_appliance_instances = {}
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
| google-beta | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Immutable. The name of the spoke. Spoke names must be unique. | `string` | n/a | yes |
| hub | Immutable. The URI of the hub that this spoke is attached to. | `string` | n/a | yes |
| location | The location for the resource | `string` | n/a | yes |
| labels | Optional labels in key:value format. | `map(string)` | n/a | yes |
| description | An optional description of the spoke. | `string` | n/a | yes |
| group | The name of the group that this spoke is associated with. | `string` | n/a | yes |
| project | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| linked_interconnect_attachments | A collection of VLAN attachment resources to connect as interconnect spokes. | <pre>map(object({<br>  uris                       = list(string)<br>  site_to_site_data_transfer = bool<br>  include_import_ranges      = list(string)<br>  exclude_import_ranges      = list(string)<br>  include_export_ranges      = list(string)<br>  exclude_export_ranges      = list(string)<br>}))</pre> | n/a | yes |
| linked_vpn_tunnels | The URIs of linked VPN tunnel resources. | <pre>map(object({<br>  uris                       = list(string)<br>  site_to_site_data_transfer = bool<br>  include_import_ranges      = list(string)<br>  exclude_import_ranges      = list(string)<br>  include_export_ranges      = list(string)<br>  exclude_export_ranges      = list(string)<br>}))</pre> | n/a | yes |
| linked_vpc_network | VPC network that is associated with the spoke. | <pre>map(object({<br>  uri                   = string<br>  exclude_export_ranges = list(string)<br>  include_export_ranges = list(string)<br>}))</pre> | n/a | yes |
| linked_producer_vpc_network | Producer VPC network that is associated with the spoke. | <pre>map(object({<br>  network               = string<br>  peering               = string<br>  include_export_ranges = list(string)<br>  exclude_export_ranges = list(string)<br>}))</pre> | n/a | yes |
| linked_router_appliance_instances | The URIs of linked Router appliance resources. | <pre>map(object({<br>  site_to_site_data_transfer = bool<br>  include_import_ranges      = list(string)<br>  exclude_import_ranges      = list(string)<br>  include_export_ranges      = list(string)<br>  exclude_export_ranges      = list(string)<br>  instances = map(object({<br>    virtual_machine = string<br>    ip_address      = string<br>  }))<br>}))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ncc_spoke_id | The ID of the created NCC spoke |
