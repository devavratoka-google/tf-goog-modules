# Region Backend Service Submodule

This submodule configures a Google Compute Regional Backend Service.

## Usage

```hcl
module "region_backend_service" {
  source                = "./modules/lb/region_backend_service"
  name                  = "my-backend-service"
  region                = "us-central1"
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "HTTP"
  health_checks         = ["my-health-check-self-link"]

  backends = [
    {
      group          = "my-instance-group-self-link"
      balancing_mode = "RATE"
      max_rate       = 100
    }
  ]
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
| [google_compute_region_backend_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backends"></a> [backends](#input\_backends) | A list of backends (Instance Groups or NEGs) attached to this service. | <pre>list(object({<br/>    group                        = string<br/>    balancing_mode               = optional(string)<br/>    capacity_scaler              = optional(number)<br/>    description                  = optional(string)<br/>    failover                     = optional(bool)<br/>    max_connections              = optional(number)<br/>    max_connections_per_endpoint = optional(number)<br/>    max_connections_per_instance = optional(number)<br/>    max_rate                     = optional(number)<br/>    max_rate_per_endpoint        = optional(number)<br/>    max_rate_per_instance        = optional(number)<br/>    max_utilization              = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_connection_draining_timeout_sec"></a> [connection\_draining\_timeout\_sec](#input\_connection\_draining\_timeout\_sec) | n/a | `number` | `0` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_enable_cdn"></a> [enable\_cdn](#input\_enable\_cdn) | n/a | `bool` | `false` | no |
| <a name="input_health_checks"></a> [health\_checks](#input\_health\_checks) | n/a | `list(string)` | `[]` | no |
| <a name="input_load_balancing_scheme"></a> [load\_balancing\_scheme](#input\_load\_balancing\_scheme) | n/a | `string` | `"INTERNAL_MANAGED"` | no |
| <a name="input_log_config"></a> [log\_config](#input\_log\_config) | n/a | <pre>object({<br/>    enable      = optional(bool, false)<br/>    sample_rate = optional(number, 1.0)<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_port_name"></a> [port\_name](#input\_port\_name) | n/a | `string` | `"http"` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | n/a | `string` | `"HTTP"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | n/a | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the region backend service. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the region backend service. |
<!-- END_TF_DOCS -->
