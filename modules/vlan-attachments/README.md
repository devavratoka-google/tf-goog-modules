# VLAN Attachments Module

This module creates a Google Cloud Compute Interconnect Attachment (VLAN Attachment) and associated VPC Flow Logs configuration.

## Usage

```hcl
module "vlan_attachments" {
  source                   = "./modules/vlan-attachments"
  router                   = "my-router"
  name                     = "my-attachment"
  region                   = "us-central1"
  project                  = "my-project-id"
  admin_enabled            = true
  edge_availability_domain = "AVAILABILITY_DOMAIN_ANY"
  vpc_flow_logs_config_id  = "my-flow-log-config"
  state                    = "ENABLED"
  aggregation_interval     = "INTERVAL_5_SEC"
  flow_sampling            = 1.0
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
| [google_compute_interconnect_attachment.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_interconnect_attachment) | resource |
| [google_network_management_vpc_flow_logs_config.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_management_vpc_flow_logs_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Whether the VLAN attachment is enabled or disabled. When using PARTNER type this will Pre-Activate the interconnect attachment | `bool` | n/a | yes |
| <a name="input_aggregation_interval"></a> [aggregation\_interval](#input\_aggregation\_interval) | Optional. The aggregation interval for the logs. Default value is INTERVAL\_5\_SEC. Possible values: AGGREGATION\_INTERVAL\_UNSPECIFIED INTERVAL\_5\_SEC INTERVAL\_30\_SEC INTERVAL\_1\_MIN INTERVAL\_5\_MIN INTERVAL\_10\_MIN INTERVAL\_15\_MIN | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. | `string` | `"VLAN Attachment"` | no |
| <a name="input_edge_availability_domain"></a> [edge\_availability\_domain](#input\_edge\_availability\_domain) | Desired availability domain for the attachment. Only available for type PARTNER, at creation time. For improved reliability, customers should configure a pair of attachments with one per availability domain. The selected availability domain will be provided to the Partner via the pairing key so that the provisioned circuit will lie in the specified domain. If not specified, the value will default to AVAILABILITY\_DOMAIN\_ANY. | `string` | n/a | yes |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | Indicates the user-supplied encryption option of this interconnect attachment. Can only be specified at attachment creation for PARTNER or DEDICATED attachments. NONE - This is the default value, which means that the VLAN attachment carries unencrypted traffic. VMs are able to send traffic to, or receive traffic from, such a VLAN attachment. IPSEC - The VLAN attachment carries only encrypted traffic that is encrypted by an IPsec device, such as an HA VPN gateway or third-party IPsec VPN. VMs cannot directly send traffic to, or receive traffic from, such a VLAN attachment. To use HA VPN over Cloud Interconnect, the VLAN attachment must be created with this option. Default value is NONE. Possible values are: NONE, IPSEC. | `string` | `"NONE"` | no |
| <a name="input_flow_sampling"></a> [flow\_sampling](#input\_flow\_sampling) | The value of the field must be in (0, 1]. The sampling rate of VPC Flow Logs where 1.0 means all collected logs are reported. Setting the sampling rate to 0.0 is not allowed. If you want to disable VPC Flow Logs, use the state field instead. Default value is 1.0. | `number` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels for this resource. These can only be added or modified by the setLabels method. Each label key/value pair must comply with RFC1035. Label values may be empty. | `map(string)` | `{}` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Configures whether all, none or a subset of metadata fields should be added to the reported VPC flow logs. Default value is INCLUDE\_ALL\_METADATA. Possible values: METADATA\_UNSPECIFIED INCLUDE\_ALL\_METADATA EXCLUDE\_ALL\_METADATA CUSTOM\_METADATA | `string` | `"INCLUDE_ALL_METADATA"` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | Maximum Transmission Unit (MTU), in bytes, of packets passing through this interconnect attachment. Valid values are 1440, 1460, 1500, and 8896. If not specified, the value will default to 1440. | `number` | `8896` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the regional interconnect attachment resides. | `string` | n/a | yes |
| <a name="input_router"></a> [router](#input\_router) | (Required) URL of the cloud router to be used for dynamic routing. This router must be in the same region as this InterconnectAttachment. The InterconnectAttachment will automatically connect the Interconnect to the network & region within which the Cloud Router is configured. | `string` | n/a | yes |
| <a name="input_state"></a> [state](#input\_state) | The state of the VPC Flow Log configuration. Default value is ENABLED. When creating a new configuration, it must be enabled. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | The type of InterconnectAttachment you wish to create. Defaults to DEDICATED. Possible values are: DEDICATED, PARTNER, PARTNER\_PROVIDER. | `string` | `"PARTNER"` | no |
| <a name="input_vlan_tag8021q"></a> [vlan\_tag8021q](#input\_vlan\_tag8021q) | The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094. When using PARTNER type this will be managed upstream. | `number` | `null` | no |
| <a name="input_vpc_flow_logs_config_id"></a> [vpc\_flow\_logs\_config\_id](#input\_vpc\_flow\_logs\_config\_id) | (Required) Required. ID of the VpcFlowLogsConfig. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_flow_logs_id"></a> [flow\_logs\_id](#output\_flow\_logs\_id) | n/a |
| <a name="output_interconnect_attachment_cloudrouter_ip"></a> [interconnect\_attachment\_cloudrouter\_ip](#output\_interconnect\_attachment\_cloudrouter\_ip) | n/a |
| <a name="output_interconnect_attachment_customerrouter_ip"></a> [interconnect\_attachment\_customerrouter\_ip](#output\_interconnect\_attachment\_customerrouter\_ip) | n/a |
| <a name="output_interconnect_attachment_id"></a> [interconnect\_attachment\_id](#output\_interconnect\_attachment\_id) | n/a |
<!-- END_TF_DOCS -->
