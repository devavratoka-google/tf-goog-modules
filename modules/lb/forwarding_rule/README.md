# Forwarding Rule Submodule

This submodule creates a regional Google Compute Forwarding Rule.

## Usage

```hcl
module "forwarding_rule" {
  source                = "./modules/lb/forwarding_rule"
  name                  = "my-forwarding-rule"
  region                = "us-central1"
  network               = "my-vpc-self-link"
  subnetwork            = "my-subnet-self-link"
  ip_protocol           = "TCP"
  ports                 = ["80", "443"]
  backend_service       = "my-backend-service-self-link"
  load_balancing_scheme = "INTERNAL"
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
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_forwarding_rule.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_global_access"></a> [allow\_global\_access](#input\_allow\_global\_access) | n/a | `bool` | `null` | no |
| <a name="input_backend_service"></a> [backend\_service](#input\_backend\_service) | n/a | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | n/a | `string` | `null` | no |
| <a name="input_ip_protocol"></a> [ip\_protocol](#input\_ip\_protocol) | n/a | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | `{}` | no |
| <a name="input_load_balancing_scheme"></a> [load\_balancing\_scheme](#input\_load\_balancing\_scheme) | n/a | `string` | `"INTERNAL"` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | n/a | `string` | `null` | no |
| <a name="input_network_tier"></a> [network\_tier](#input\_network\_tier) | n/a | `string` | `null` | no |
| <a name="input_port_range"></a> [port\_range](#input\_port\_range) | n/a | `string` | `null` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | n/a | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service_directory_registrations"></a> [service\_directory\_registrations](#input\_service\_directory\_registrations) | Service Directory registration configuration. | <pre>object({<br/>    namespace = optional(string)<br/>    service   = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | n/a | `string` | `null` | no |
| <a name="input_target"></a> [target](#input\_target) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the forwarding rule. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the forwarding rule. |
<!-- END_TF_DOCS -->
