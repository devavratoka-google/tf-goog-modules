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
| [google_compute_router.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_interface.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_interface) | resource |
| [google_compute_router_peer.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_peer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advertise_mode"></a> [advertise\_mode](#input\_advertise\_mode) | User-specified flag to indicate which mode to use for advertisement. Default value is DEFAULT. Possible values are: DEFAULT, CUSTOM. | `string` | n/a | yes |
| <a name="input_advertised_groups"></a> [advertised\_groups](#input\_advertised\_groups) | User-specified list of prefix groups to advertise in custom mode. This field can only be populated if advertiseMode is CUSTOM and is advertised to all peers of the router. These groups will be advertised in addition to any specified prefixes. Leave this field blank to advertise no custom groups. This enum field has the one valid value: ALL\_SUBNETS | `list(string)` | n/a | yes |
| <a name="input_advertised_ip_ranges"></a> [advertised\_ip\_ranges](#input\_advertised\_ip\_ranges) | User-specified list of individual IP ranges to advertise in custom mode. This field can only be populated if advertiseMode is CUSTOM and is advertised to all peers of the router. These IP ranges will be advertised in addition to any specified groups. Leave this field blank to advertise no custom IP ranges. | <pre>map(object({<br/>    range       = string // (Required) The IP range to advertise. The value must be a CIDR-formatted string.<br/>    description = string // User-specified description for the IP range.<br/>  }))</pre> | n/a | yes |
| <a name="input_asn"></a> [asn](#input\_asn) | (Required) Local BGP Autonomous System Number (ASN). Must be an RFC6996 private ASN, either 16-bit or 32-bit. The value will be fixed for this router resource. All VPN tunnels that link to this router will have the same local ASN. | `number` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. | `string` | n/a | yes |
| <a name="input_encrypted_interconnect_router"></a> [encrypted\_interconnect\_router](#input\_encrypted\_interconnect\_router) | Indicates if a router is dedicated for use with encrypted VLAN attachments (interconnectAttachments). | `bool` | n/a | yes |
| <a name="input_identifier_range"></a> [identifier\_range](#input\_identifier\_range) | Explicitly specifies a range of valid BGP Identifiers for this Router. It is provided as a link-local IPv4 range (from 169.254.0.0/16), of size at least /30, even if the BGP sessions are over IPv6. It must not overlap with any IPv4 BGP session ranges. Other vendors commonly call this router ID. | `string` | n/a | yes |
| <a name="input_keepalive_interval"></a> [keepalive\_interval](#input\_keepalive\_interval) | The interval in seconds between BGP keepalive messages that are sent to the peer. Hold time is three times the interval at which keepalive messages are sent, and the hold time is the maximum number of seconds allowed to elapse between successive keepalive messages that BGP receives from a peer. BGP will use the smaller of either the local hold time value or the peer's hold time value as the hold time for the BGP connection between the two peers. If set, this value must be between 20 and 60. The default is 20. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the resource. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | value(Required) A reference to the network to which this router belongs. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the router resides. | `string` | n/a | yes |
| <a name="input_router_interfaces"></a> [router\_interfaces](#input\_router\_interfaces) | n/a | <pre>map(object({<br/>    interface_name = string // (Required) A unique name for the interface, required by GCE. Changing this forces a new interface to be created.<br/>    ip_range       = string // IP address and range of the interface. The IP range must be in the RFC3927 link-local IP space. Changing this forces a new interface to be created.<br/>    ip_version     = string // IP version of this interface. Can be either IPV4 or IPV6.<br/>    // Only one of vpn_tunnel, interconnect_attachment or subnetwork can be specified.<br/>    vpn_tunnel              = string // The name or resource link to the VPN tunnel this interface will be linked to. Changing this forces a new interface to be created.<br/>    interconnect_attachment = string // The name or resource link to the VLAN interconnect for this interface. Changing this forces a new interface to be created.<br/>    redundant_interface     = string // The name of the interface that is redundant to this interface. Changing this forces a new interface to be created.<br/>    subnetwork              = string // The URI of the subnetwork resource that this interface belongs to, which must be in the same region as the Cloud Router. When you establish a BGP session to a VM instance using this interface, the VM instance must belong to the same subnetwork as the subnetwork specified here. Changing this forces a new interface to be created.<br/>    private_ip_address      = string // The regional private internal IP address that is used to establish BGP sessions to a VM instance acting as a third-party Router Appliance. Changing this forces a new interface to be created.<br/>  }))</pre> | n/a | yes |
| <a name="input_router_peers"></a> [router\_peers](#input\_router\_peers) | n/a | <pre>map(object({<br/>    peer_name                 = string<br/>    interface                 = string<br/>    peer_asn                  = number<br/>    ip_address                = string<br/>    peer_ip_address           = string<br/>    advertised_route_priority = number<br/>    advertise_mode            = string<br/>    advertised_groups         = list(string)<br/>    advertised_ip_ranges = map(object({<br/>      range       = string<br/>      description = string<br/>    }))<br/>    # custom_learned_route_priority = number<br/>    # custom_learned_ip_ranges = map(object({<br/>    #   range = string<br/>    # }))<br/>    bfd = map(object({<br/>      session_initialization_mode = string<br/>      min_receive_interval        = number<br/>      min_transmit_interval       = number<br/>      multiplier                  = number<br/>    }))<br/>    enable                    = bool<br/>    router_appliance_instance = string<br/>    enable_ipv6               = bool<br/>    enable_ipv4               = bool<br/>    # ipv4_nexthop_address      = string<br/>    # ipv6_nexthop_address      = string<br/>    # peer_ipv4_nexthop_address = string<br/>    # peer_ipv6_nexthop_address = string<br/>    md5_authentication_key = map(object({<br/>      name = string<br/>      key  = string<br/>    }))<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_router_id"></a> [router\_id](#output\_router\_id) | The ID of the router. |
| <a name="output_router_link"></a> [router\_link](#output\_router\_link) | n/a |
| <a name="output_router_name"></a> [router\_name](#output\_router\_name) | n/a |
| <a name="output_router_project"></a> [router\_project](#output\_router\_project) | n/a |
| <a name="output_router_region"></a> [router\_region](#output\_router\_region) | n/a |
<!-- END_TF_DOCS -->
