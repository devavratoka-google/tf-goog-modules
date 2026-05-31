# Cloud NAT Module

This module creates a Google Cloud Compute Router NAT.

## Usage

```hcl
module "cloud_nat" {
  source                             = "./modules/cloud_nat"
  name                               = "my-nat"
  router                             = "my-router"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
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
| [google_compute_router_nat.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_network_tier"></a> [auto\_network\_tier](#input\_auto\_network\_tier) | The network tier to use when automatically reserving NAT IP addresses. Must be one of: PREMIUM, STANDARD. If not specified, then the current project-level default tier is used. Possible values are: PREMIUM, STANDARD. | `string` | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | (Required) Indicates whether or not to export logs. | `bool` | n/a | yes |
| <a name="input_enable_dynamic_port_allocation"></a> [enable\_dynamic\_port\_allocation](#input\_enable\_dynamic\_port\_allocation) | Enable Dynamic Port Allocation. If minPortsPerVm is set, minPortsPerVm must be set to a power of two greater than or equal to 32. If minPortsPerVm is not set, a minimum of 32 ports will be allocated to a VM from this NAT config. If maxPortsPerVm is set, maxPortsPerVm must be set to a power of two greater than minPortsPerVm. If maxPortsPerVm is not set, a maximum of 65536 ports will be allocated to a VM from this NAT config. Mutually exclusive with enableEndpointIndependentMapping. | `bool` | n/a | yes |
| <a name="input_enable_endpoint_independent_mapping"></a> [enable\_endpoint\_independent\_mapping](#input\_enable\_endpoint\_independent\_mapping) | Enable endpoint independent mapping. | `bool` | n/a | yes |
| <a name="input_endpoint_types"></a> [endpoint\_types](#input\_endpoint\_types) | Specifies the endpoint Types supported by the NAT Gateway. Supported values include: ENDPOINT\_TYPE\_VM, ENDPOINT\_TYPE\_SWG, ENDPOINT\_TYPE\_MANAGED\_PROXY\_LB | `list(string)` | n/a | yes |
| <a name="input_filter"></a> [filter](#input\_filter) | (Required) Specifies the desired filtering of logs on this NAT. Possible values are: ERRORS\_ONLY, TRANSLATIONS\_ONLY, ALL. | `string` | n/a | yes |
| <a name="input_icmp_idle_timeout_sec"></a> [icmp\_idle\_timeout\_sec](#input\_icmp\_idle\_timeout\_sec) | Timeout (in seconds) for ICMP connections. Defaults to 30s if not set. | `number` | n/a | yes |
| <a name="input_max_ports_per_vm"></a> [max\_ports\_per\_vm](#input\_max\_ports\_per\_vm) | Maximum number of ports allocated to a VM from this NAT. This field can only be set when enableDynamicPortAllocation is enabled. | `number` | n/a | yes |
| <a name="input_min_ports_per_vm"></a> [min\_ports\_per\_vm](#input\_min\_ports\_per\_vm) | Minimum number of ports allocated to a VM from this NAT. Defaults to 64 for static port allocation and 32 dynamic port allocation if not set. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the NAT service. The name must be 1-63 characters long and comply with RFC1035. | `string` | n/a | yes |
| <a name="input_nat_ip_allocate_option"></a> [nat\_ip\_allocate\_option](#input\_nat\_ip\_allocate\_option) | How external IPs should be allocated for this NAT. Valid values are AUTO\_ONLY for only allowing NAT IPs allocated by Google Cloud Platform, or MANUAL\_ONLY for only user-allocated NAT IP addresses. Possible values are: MANUAL\_ONLY, AUTO\_ONLY. | `string` | n/a | yes |
| <a name="input_nat_ips"></a> [nat\_ips](#input\_nat\_ips) | Self-links of NAT IPs. Only valid if natIpAllocateOption is set to MANUAL\_ONLY. If this field is used alongside with a count created list of address resources google\_compute\_address.foobar.*.self\_link, the access level resource for the address resource must have a lifecycle block with create\_before\_destroy = true so the number of resources can be increased/decreased without triggering the resourceInUseByAnotherResource error. | `set(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the router and NAT reside. | `string` | n/a | yes |
| <a name="input_router"></a> [router](#input\_router) | (Required) The name of the Cloud Router in which this NAT will be configured. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | A list of rules associated with this NAT. | <pre>map(object({<br/>    rule_number = number                   // (Required) An integer uniquely identifying a rule in the list. The rule number must be a positive value between 0 and 65000, and must be unique among rules within a NAT.<br/>    match       = string                   // (Required) CEL expression that specifies the match condition that egress traffic from a VM is evaluated against. If it evaluates to true, the corresponding action is enforced. The following examples are valid match expressions for public NAT: "inIpRange(destination.ip, '1.1.0.0/16') || inIpRange(destination.ip, '2.2.0.0/16')" "destination.ip == '1.1.0.1' || destination.ip == '8.8.8.8'" The following example is a valid match expression for private NAT: "nexthop.hub == 'https://networkconnectivity.googleapis.com/v1alpha1/projects/my-project/global/hub/hub-1'"<br/>    description = string                   // An optional description of this rule.<br/>    action = object({                      // The action to be enforced for traffic that matches this rule.<br/>      source_nat_active_ips = list(string) // A list of URLs of the IP resources used for this NAT rule. These IP addresses must be valid static external IP addresses assigned to the project. This field is used for public NAT.<br/>      source_nat_drain_ips  = list(string) // A list of URLs of the IP resources to be drained. These IPs must be valid static external IPs that have been assigned to the NAT. These IPs should be used for updating/patching a NAT rule only. This field is used for public NAT.<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_source_subnetwork_ip_ranges_to_nat"></a> [source\_subnetwork\_ip\_ranges\_to\_nat](#input\_source\_subnetwork\_ip\_ranges\_to\_nat) | (Required) How NAT should be configured per Subnetwork. If ALL\_SUBNETWORKS\_ALL\_IP\_RANGES, all of the IP ranges in every Subnetwork are allowed to Nat. If ALL\_SUBNETWORKS\_ALL\_PRIMARY\_IP\_RANGES, all of the primary IP ranges in every Subnetwork are allowed to Nat. LIST\_OF\_SUBNETWORKS: A list of Subnetworks are allowed to Nat (specified in the field subnetwork below). Note that if this field contains ALL\_SUBNETWORKS\_ALL\_IP\_RANGES or ALL\_SUBNETWORKS\_ALL\_PRIMARY\_IP\_RANGES, then there should not be any other RouterNat section in any Router for this network in this region. Possible values are: ALL\_SUBNETWORKS\_ALL\_IP\_RANGES, ALL\_SUBNETWORKS\_ALL\_PRIMARY\_IP\_RANGES, LIST\_OF\_SUBNETWORKS. | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | One or more subnetwork NAT configurations. Only used if source\_subnetwork\_ip\_ranges\_to\_nat is set to LIST\_OF\_SUBNETWORKS | <pre>map(object({<br/>    name                     = string      // (Required) Self-link of subnetwork to NAT<br/>    source_ip_ranges_to_nat  = set(string) // (Required) List of options for which source IPs in the subnetwork should have NAT enabled. Supported values include: ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE.<br/>    secondary_ip_range_names = set(string) // List of the secondary ranges of the subnetwork that are allowed to use NAT. This can be populated only if LIST_OF_SECONDARY_IP_RANGES is one of the values in sourceIpRangesToNat<br/>  }))</pre> | n/a | yes |
| <a name="input_tcp_established_idle_timeout_sec"></a> [tcp\_established\_idle\_timeout\_sec](#input\_tcp\_established\_idle\_timeout\_sec) | Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set. | `number` | n/a | yes |
| <a name="input_tcp_time_wait_timeout_sec"></a> [tcp\_time\_wait\_timeout\_sec](#input\_tcp\_time\_wait\_timeout\_sec) | Timeout (in seconds) for TCP connections that are in TIME\_WAIT state. Defaults to 120s if not set. | `number` | n/a | yes |
| <a name="input_tcp_transitory_idle_timeout_sec"></a> [tcp\_transitory\_idle\_timeout\_sec](#input\_tcp\_transitory\_idle\_timeout\_sec) | Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set. | `number` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Indicates whether this NAT is used for public or private IP translation. If unspecified, it defaults to PUBLIC. If PUBLIC NAT used for public IP translation. If PRIVATE NAT used for private IP translation. Default value is PUBLIC. Possible values are: PUBLIC, PRIVATE. | `string` | n/a | yes |
| <a name="input_udp_idle_timeout_sec"></a> [udp\_idle\_timeout\_sec](#input\_udp\_idle\_timeout\_sec) | Timeout (in seconds) for UDP connections. Defaults to 30s if not set. | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
