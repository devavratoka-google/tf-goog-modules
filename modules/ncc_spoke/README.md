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
| [google-beta_google_network_connectivity_spoke.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_network_connectivity_spoke) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | An optional description of the spoke. | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | The name of the group that this spoke is associated with. | `string` | n/a | yes |
| <a name="input_hub"></a> [hub](#input\_hub) | (Required) Immutable. The URI of the hub that this spoke is attached to. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Optional labels in key:value format. For more information about labels, see Requirements for labels. Note: This field is non-authoritative, and will only manage the labels present in your configuration. Please refer to the field effective\_labels for all of the labels present on the resource. | `map(string)` | n/a | yes |
| <a name="input_linked_interconnect_attachments"></a> [linked\_interconnect\_attachments](#input\_linked\_interconnect\_attachments) | A collection of VLAN attachment resources. These resources should be redundant attachments that all advertise the same prefixes to Google Cloud. Alternatively, in active/passive configurations, all attachments should be capable of advertising the same prefixes. | <pre>map(object({<br/>    uris                       = list(string) // (Required) The URIs of linked interconnect attachment resources<br/>    site_to_site_data_transfer = bool         // Required) A value that controls whether site-to-site data transfer is enabled for these resources. Note that data transfer is available only in supported locations.<br/>    include_import_ranges      = list(string) // Hub routes fully encompassed by include import ranges are included during import from hub. "ALL_IPV4_RANGES" or IPv4 CIDR ranges are allowed.<br/>    exclude_import_ranges      = list(string) // Hub routes overlapped/encompassed by exclude import ranges are excluded during import from hub.<br/>    include_export_ranges      = list(string) // Dynamic routes fully encompassed by include export ranges are included during export to hub.<br/>    exclude_export_ranges      = list(string) // Dynamic routes overlapped/encompassed by exclude export ranges are excluded during export to hub.<br/>  }))</pre> | n/a | yes |
| <a name="input_linked_producer_vpc_network"></a> [linked\_producer\_vpc\_network](#input\_linked\_producer\_vpc\_network) | Producer VPC network that is associated with the spoke. | <pre>map(object({<br/>    network = string // (Required) The URI of the Service Consumer VPC that the Producer VPC is peered with.<br/>    peering = string // (Required) The name of the VPC peering between the Service Consumer VPC and the Producer VPC (defined in the Tenant project) which is added to the NCC hub. This peering must be in ACTIVE state.<br/>    # producer_network      = string       // The URI of the Producer VPC.<br/>    include_export_ranges = list(string) // IP ranges allowed to be included from peering.<br/>    exclude_export_ranges = list(string) // IP ranges encompassing the subnets to be excluded from peering.<br/>  }))</pre> | n/a | yes |
| <a name="input_linked_router_appliance_instances"></a> [linked\_router\_appliance\_instances](#input\_linked\_router\_appliance\_instances) | The URIs of linked Router appliance resources | <pre>map(object({<br/>    site_to_site_data_transfer = bool         // (Required) A value that controls whether site-to-site data transfer is enabled for these resources. Note that data transfer is available only in supported locations.<br/>    include_import_ranges      = list(string) // Hub routes fully encompassed by include import ranges are included during import from hub. "ALL_IPV4_RANGES" or IPv4 CIDR ranges are allowed.<br/>    exclude_import_ranges      = list(string) // Hub routes overlapped/encompassed by exclude import ranges are excluded during import from hub.<br/>    include_export_ranges      = list(string) // Dynamic routes fully encompassed by include export ranges are included during export to hub.<br/>    exclude_export_ranges      = list(string) // Dynamic routes overlapped/encompassed by exclude export ranges are excluded during export to hub.<br/>    instances = map(object({                  // (Required) The list of router appliance instances<br/>      virtual_machine = string                // (Required) The URI of the virtual machine resource<br/>      ip_address      = string                // (Required) The IP address on the VM to use for peering.<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_linked_vpc_network"></a> [linked\_vpc\_network](#input\_linked\_vpc\_network) | VPC network that is associated with the spoke. | <pre>map(object({<br/>    uri                   = string       // (Required) The URI of the VPC network resource.<br/>    exclude_export_ranges = list(string) // IP ranges encompassing the subnets to be excluded from peering.<br/>    include_export_ranges = list(string) // IP ranges allowed to be included from peering.<br/>  }))</pre> | n/a | yes |
| <a name="input_linked_vpn_tunnels"></a> [linked\_vpn\_tunnels](#input\_linked\_vpn\_tunnels) | The URIs of linked VPN tunnel resources | <pre>map(object({<br/>    uris                       = list(string) // (Required) The URIs of linked VPN tunnel resources.<br/>    site_to_site_data_transfer = bool         // (Required) A value that controls whether site-to-site data transfer is enabled for these resources. Note that data transfer is available only in supported locations.<br/>    include_import_ranges      = list(string) // Hub routes fully encompassed by include import ranges are included during import from hub. "ALL_IPV4_RANGES" or IPv4 CIDR ranges are allowed.<br/>    exclude_import_ranges      = list(string) // Hub routes overlapped/encompassed by exclude import ranges are excluded during import from hub.<br/>    include_export_ranges      = list(string) // Dynamic routes fully encompassed by include export ranges are included during export to hub.<br/>    exclude_export_ranges      = list(string) // Dynamic routes overlapped/encompassed by exclude export ranges are excluded during export to hub.<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location for the resource | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Immutable. The name of the spoke. Spoke names must be unique. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ncc_spoke_id"></a> [ncc\_spoke\_id](#output\_ncc\_spoke\_id) | The ID of the NCC Spoke. |
| <a name="output_ncc_spoke_name"></a> [ncc\_spoke\_name](#output\_ncc\_spoke\_name) | The name of the NCC Spoke. |
| <a name="output_ncc_spoke_unique_id"></a> [ncc\_spoke\_unique\_id](#output\_ncc\_spoke\_unique\_id) | The unique ID of the NCC Spoke. |
<!-- END_TF_DOCS -->
