# DNS Policy Module

This module creates a Google Cloud DNS Policy.

## Usage

```hcl
module "dns_policy" {
  source  = "./modules/dns_policy"
  project = "my-project-id"
  name    = "my-dns-policy"
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
| project | The ID of the project where the DNS policy will be created | `string` | n/a | yes |
| name | The name of the DNS policy | `string` | n/a | yes |
| enable_inbound_forwarding | Whether to enable inbound forwarding | `bool` | `false` | no |
| enable_logging | Whether to enable logging for the policy | `bool` | `false` | no |
| networks | The list of VPC networks that this policy applies to | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy_id | The ID of the DNS policy |
