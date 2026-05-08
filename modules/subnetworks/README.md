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
| project | The ID of the project where this VPC will be created | `string` | n/a | yes |
| network | The network this subnet belongs to | `string` | n/a | yes |
| name | The name of the resource | `string` | n/a | yes |
| description | An optional description of this resource | `string` | n/a | yes |
| ip_cidr_range | The range of internal addresses | `string` | n/a | yes |
| reserved_internal_range | The ID of the reserved internal range | `string` | n/a | yes |
| purpose | The purpose of the resource | `string` | n/a | yes |
| role | The role of subnetwork | `string` | n/a | yes |
| private_ip_google_access | When enabled, VMs can access Google APIs | `bool` | n/a | yes |
| private_ipv6_google_access | The private IPv6 google access type | `string` | n/a | yes |
| region | The GCP region for this subnetwork | `string` | n/a | yes |
| stack_type | The stack type for this subnet | `string` | n/a | yes |
| ipv6_access_type | The access type of IPv6 address | `string` | n/a | yes |
| external_ipv6_prefix | The range of external IPv6 addresses | `string` | n/a | yes |
| send_secondary_ip_range_if_empty | Controls the removal behavior of secondary_ip_range | `bool` | n/a | yes |
| secondary_ip_range | Map of object for secondary IP ranges | `map(object)` | n/a | yes |
| log_config | Object for log configuration | `object` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| subnets_self_link | The self link of subnetworks |
| subnets_name | The name of subnetworks |
| subnets_project | The project of subnetworks |
| subnets_region | The region of subnetworks |
