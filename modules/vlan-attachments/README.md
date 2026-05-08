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
| router | URL of the cloud router | `string` | n/a | yes |
| name | Name of the resource | `string` | n/a | yes |
| region | Region where the resource resides | `string` | n/a | yes |
| project | The ID of the project in which the resource belongs | `string` | n/a | yes |
| admin_enabled | Whether the VLAN attachment is enabled or disabled | `bool` | n/a | yes |
| description | An optional description of this resource | `string` | `"VLAN Attachment"` | no |
| mtu | Maximum Transmission Unit (MTU) | `number` | `8896` | no |
| edge_availability_domain | Desired availability domain | `string` | n/a | yes |
| type | The type of InterconnectAttachment | `string` | `"PARTNER"` | no |
| vlan_tag8021q | The IEEE 802.1Q VLAN tag | `number` | `null` | no |
| encryption | Indicates the user-supplied encryption option | `string` | `"NONE"` | no |
| labels | Labels for this resource | `map(string)` | `{}` | no |
| vpc_flow_logs_config_id | ID of the VpcFlowLogsConfig | `string` | n/a | yes |
| state | The state of the VPC Flow Log configuration | `string` | n/a | yes |
| aggregation_interval | The aggregation interval for the logs | `string` | n/a | yes |
| flow_sampling | The sampling rate of VPC Flow Logs | `number` | n/a | yes |
| metadata | Configures whether metadata fields should be added | `string` | `"INCLUDE_ALL_METADATA"` | no |

## Outputs

| Name | Description |
|------|-------------|
| interconnect_attachment_id | The interconnect attachment resource |
| interconnect_attachment_cloudrouter_ip | The Cloud Router IP address |
| interconnect_attachment_customerrouter_ip | The Customer Router IP address |
| flow_logs_id | The ID of the VPC Flow Log configuration |
