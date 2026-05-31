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
| [google_dns_policy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_inbound_forwarding"></a> [enable\_inbound\_forwarding](#input\_enable\_inbound\_forwarding) | Whether to enable inbound forwarding | `bool` | `false` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Whether to enable logging for the policy | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the DNS policy | `string` | n/a | yes |
| <a name="input_networks"></a> [networks](#input\_networks) | The list of VPC networks that this policy applies to | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project where the DNS policy will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | The ID of the DNS policy |
<!-- END_TF_DOCS -->
