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
| name | Name of the NAT service | `string` | n/a | yes |
| source_subnetwork_ip_ranges_to_nat | How NAT should be configured per Subnetwork | `string` | n/a | yes |
| router | The name of the Cloud Router | `string` | n/a | yes |
| nat_ip_allocate_option | How external IPs should be allocated | `string` | n/a | yes |
| nat_ips | Self-links of NAT IPs | `set(string)` | n/a | yes |
| subnetwork | One or more subnetwork NAT configurations | `map(object)` | n/a | yes |
| min_ports_per_vm | Minimum number of ports allocated to a VM | `number` | n/a | yes |
| max_ports_per_vm | Maximum number of ports allocated to a VM | `number` | n/a | yes |
| enable_dynamic_port_allocation | Enable Dynamic Port Allocation | `bool` | n/a | yes |
| udp_idle_timeout_sec | Timeout for UDP connections | `number` | n/a | yes |
| icmp_idle_timeout_sec | Timeout for ICMP connections | `number` | n/a | yes |
| tcp_established_idle_timeout_sec | Timeout for TCP established connections | `number` | n/a | yes |
| tcp_transitory_idle_timeout_sec | Timeout for TCP transitory connections | `number` | n/a | yes |
| tcp_time_wait_timeout_sec | Timeout for TCP connections in TIME_WAIT | `number` | n/a | yes |
| enable | Indicates whether or not to export logs | `bool` | n/a | yes |
| filter | Specifies the desired filtering of logs | `string` | n/a | yes |
| endpoint_types | Specifies the endpoint Types supported | `list(string)` | n/a | yes |
| rules | A list of rules associated with this NAT | `map(object)` | n/a | yes |
| enable_endpoint_independent_mapping | Enable endpoint independent mapping | `bool` | n/a | yes |
| type | Indicates whether this NAT is used for public or private IP translation | `string` | n/a | yes |
| auto_network_tier | The network tier to use when automatically reserving NAT IP addresses | `string` | n/a | yes |
| region | Region where the router and NAT reside | `string` | n/a | yes |
| project | The ID of the project in which the resource belongs | `string` | n/a | yes |

## Outputs

No outputs.
