# Subnetworks Module

This module creates a Google Cloud Compute Subnetwork.

## Usage

```hcl
module "subnetworks" {
  source      = "./modules/subnetworks"
  project     = "my-project-id"
  network     = "my-vpc-self-link"
  name        = "my-subnet"
  region      = "us-central1"
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
| [google_compute_subnetwork.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. Provide this property when you create the resource. This field can be set only at resource creation time. | `string` | n/a | yes |
| <a name="input_external_ipv6_prefix"></a> [external\_ipv6\_prefix](#input\_external\_ipv6\_prefix) | The range of external IPv6 addresses that are owned by this subnetwork. | `string` | n/a | yes |
| <a name="input_ip_cidr_range"></a> [ip\_cidr\_range](#input\_ip\_cidr\_range) | The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported. Field is optional when reserved\_internal\_range is defined, otherwise required. | `string` | n/a | yes |
| <a name="input_ipv6_access_type"></a> [ipv6\_access\_type](#input\_ipv6\_access\_type) | The access type of IPv6 address this subnet holds. It's immutable and can only be specified during creation or the first time the subnet is updated into IPV4\_IPV6 dual stack. If the ipv6\_type is EXTERNAL then this subnet cannot enable direct path. Possible values are: EXTERNAL, INTERNAL. | `string` | n/a | yes |
| <a name="input_log_config"></a> [log\_config](#input\_log\_config) | n/a | <pre>object({<br/>    aggregation_interval = string      // Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Default is an interval of 5 seconds per connection. Default value is INTERVAL_5_SEC. Possible values are: INTERVAL_5_SEC, INTERVAL_30_SEC, INTERVAL_1_MIN, INTERVAL_5_MIN, INTERVAL_10_MIN, INTERVAL_15_MIN.<br/>    flow_sampling        = number      // Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in [0, 1]. Set the sampling rate of VPC flow logs within the subnetwork where 1.0 means all collected logs are reported and 0.0 means no logs are reported. Default is 0.5 which means half of all collected logs are reported.<br/>    metadata             = string      // Can only be specified if VPC flow logging for this subnetwork is enabled. Configures whether metadata fields should be added to the reported VPC flow logs. Default value is INCLUDE_ALL_METADATA. Possible values are: EXCLUDE_ALL_METADATA, INCLUDE_ALL_METADATA, CUSTOM_METADATA.<br/>    metadata_fields      = set(string) // List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is enabled and 'metadata' is set to CUSTOM_METADATA.<br/>    filter_expr          = string      // Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field. The default value is 'true', which evaluates to include everything.<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the resource, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The network this subnet belongs to. Only networks that are in the distributed mode can have subnetworks. | `string` | n/a | yes |
| <a name="input_private_ip_google_access"></a> [private\_ip\_google\_access](#input\_private\_ip\_google\_access) | When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access. | `bool` | n/a | yes |
| <a name="input_private_ipv6_google_access"></a> [private\_ipv6\_google\_access](#input\_private\_ipv6\_google\_access) | The private IPv6 google access type for the VMs in this subnet. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project where this VPC will be created | `string` | n/a | yes |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the resource. This field can be either PRIVATE, REGIONAL\_MANAGED\_PROXY, GLOBAL\_MANAGED\_PROXY, PRIVATE\_SERVICE\_CONNECT, PEER\_MIGRATION or PRIVATE\_NAT(Beta). <br/>  A subnet with purpose set to REGIONAL\_MANAGED\_PROXY is a user-created subnetwork that is reserved for regional Envoy-based load balancers. A subnetwork in a given region with purpose set to GLOBAL\_MANAGED\_PROXY is a proxy-only subnet and is shared between all the cross-regional Envoy-based load balancers. <br/>  A subnetwork with purpose set to PRIVATE\_SERVICE\_CONNECT reserves the subnet for hosting a Private Service Connect published service. A subnetwork with purpose set to PEER\_MIGRATION is a user created subnetwork that is reserved for migrating resources from one peered network to another. <br/>  A subnetwork with purpose set to PRIVATE\_NAT is used as source range for Private NAT gateways. <br/>  Note that REGIONAL\_MANAGED\_PROXY is the preferred setting for all regional Envoy load balancers. If unspecified, the purpose defaults to PRIVATE. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for this subnetwork. | `string` | n/a | yes |
| <a name="input_reserved_internal_range"></a> [reserved\_internal\_range](#input\_reserved\_internal\_range) | The ID of the reserved internal range. Must be prefixed with networkconnectivity.googleapis.com E.g. networkconnectivity.googleapis.com/projects/{project}/locations/global/internalRanges/{rangeId} | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | The role of subnetwork. Currently, this field is only used when purpose is REGIONAL\_MANAGED\_PROXY. The value can be set to ACTIVE or BACKUP. An ACTIVE subnetwork is one that is currently being used for Envoy-based load balancers in a region. A BACKUP subnetwork is one that is ready to be promoted to ACTIVE or is currently draining. Possible values are: ACTIVE, BACKUP. | `string` | n/a | yes |
| <a name="input_secondary_ip_range"></a> [secondary\_ip\_range](#input\_secondary\_ip\_range) | n/a | <pre>map(object({<br/>    range_name              = string // (Required) The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.<br/>    ip_cidr_range           = string // The range of IP addresses belonging to this subnetwork secondary range. Provide this property when you create the subnetwork. Ranges must be unique and non-overlapping with all primary and secondary IP ranges within a network. Only IPv4 is supported. Field is optional when reserved_internal_range is defined, otherwise required.<br/>    reserved_internal_range = string // The ID of the reserved internal range. Must be prefixed with networkconnectivity.googleapis.com E.g. networkconnectivity.googleapis.com/projects/{project}/locations/global/internalRanges/{rangeId}<br/>  }))</pre> | n/a | yes |
| <a name="input_send_secondary_ip_range_if_empty"></a> [send\_secondary\_ip\_range\_if\_empty](#input\_send\_secondary\_ip\_range\_if\_empty) | Controls the removal behavior of secondary\_ip\_range. When false, removing secondary\_ip\_range from config will not produce a diff as the provider will default to the API's value. When true, the provider will treat removing secondary\_ip\_range as sending an empty list of secondary IP ranges to the API. Defaults to false. | `bool` | n/a | yes |
| <a name="input_stack_type"></a> [stack\_type](#input\_stack\_type) | The stack type for this subnet to identify whether the IPv6 feature is enabled or not. If not specified IPV4\_ONLY will be used. Possible values are: IPV4\_ONLY, IPV4\_IPV6, IPV6\_ONLY. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets_id"></a> [subnets\_id](#output\_subnets\_id) | The ID of subnetworks |
| <a name="output_subnets_name"></a> [subnets\_name](#output\_subnets\_name) | The name of subnetworks |
| <a name="output_subnets_project"></a> [subnets\_project](#output\_subnets\_project) | n/a |
| <a name="output_subnets_region"></a> [subnets\_region](#output\_subnets\_region) | n/a |
| <a name="output_subnets_self_link"></a> [subnets\_self\_link](#output\_subnets\_self\_link) | The self link of subnetworks |
<!-- END_TF_DOCS -->
