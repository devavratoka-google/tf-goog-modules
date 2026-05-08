# DNS Module

This module creates a Google Cloud DNS Managed Zone and record sets.

## Usage

```hcl
module "dns" {
  source   = "./modules/dns"
  project  = "my-project-id"
  name     = "my-zone"
  dns_name = "example.com."
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
| project | The ID of the project where the DNS resources will be created | `string` | n/a | yes |
| name | The name of the managed zone | `string` | n/a | yes |
| dns_name | The DNS name of this managed zone | `string` | n/a | yes |
| description | A description of this managed zone | `string` | `"Managed by Terraform"` | no |
| visibility | The zone's visibility: public or private | `string` | `"private"` | no |
| networks | For private zones, the list of VPC networks that can see this zone | `list(string)` | `[]` | no |
| forwarding_config | The presence of this field indicates that outbound forwarding is enabled | `object` | `null` | no |
| peering_config | The presence of this field indicates that DNS peering is enabled | `object` | `null` | no |
| record_sets | Map of record sets to create in the zone | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| managed_zone_name | The name of the managed zone |
| managed_zone_id | The ID of the managed zone |
