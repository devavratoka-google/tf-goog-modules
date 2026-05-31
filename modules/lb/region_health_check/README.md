# Region Health Check Submodule

This submodule configures a Google Compute Regional Health Check. It supports TCP, HTTP, HTTPS, HTTP2, SSL, and gRPC health check protocols.

## Usage

```hcl
module "region_health_check" {
  source             = "./modules/lb/region_health_check"
  name               = "my-health-check"
  region             = "us-central1"
  check_interval_sec = 10
  timeout_sec        = 5

  http_health_check = {
    port         = 80
    request_path = "/healthz"
  }
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
| [google_compute_region_health_check.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_health_check) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_check_interval_sec"></a> [check\_interval\_sec](#input\_check\_interval\_sec) | n/a | `number` | `5` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_grpc_health_check"></a> [grpc\_health\_check](#input\_grpc\_health\_check) | n/a | <pre>object({<br/>    port               = optional(number)<br/>    port_specification = optional(string)<br/>    port_name          = optional(string)<br/>    grpc_service_name  = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | n/a | `number` | `2` | no |
| <a name="input_http2_health_check"></a> [http2\_health\_check](#input\_http2\_health\_check) | n/a | <pre>object({<br/>    port               = optional(number)<br/>    port_specification = optional(string)<br/>    port_name          = optional(string)<br/>    host               = optional(string)<br/>    request_path       = optional(string)<br/>    response           = optional(string)<br/>    proxy_header       = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_http_health_check"></a> [http\_health\_check](#input\_http\_health\_check) | n/a | <pre>object({<br/>    port               = optional(number)<br/>    port_specification = optional(string)<br/>    port_name          = optional(string)<br/>    host               = optional(string)<br/>    request_path       = optional(string)<br/>    response           = optional(string)<br/>    proxy_header       = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_https_health_check"></a> [https\_health\_check](#input\_https\_health\_check) | n/a | <pre>object({<br/>    port               = optional(number)<br/>    port_specification = optional(string)<br/>    port_name          = optional(string)<br/>    host               = optional(string)<br/>    request_path       = optional(string)<br/>    response           = optional(string)<br/>    proxy_header       = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_log_config"></a> [log\_config](#input\_log\_config) | n/a | <pre>object({<br/>    enable = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_ssl_health_check"></a> [ssl\_health\_check](#input\_ssl\_health\_check) | n/a | <pre>object({<br/>    port               = optional(number)<br/>    port_specification = optional(string)<br/>    port_name          = optional(string)<br/>    request            = optional(string)<br/>    response           = optional(string)<br/>    proxy_header       = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_tcp_health_check"></a> [tcp\_health\_check](#input\_tcp\_health\_check) | n/a | <pre>object({<br/>    port               = optional(number)<br/>    port_specification = optional(string)<br/>    port_name          = optional(string)<br/>    request            = optional(string)<br/>    response           = optional(string)<br/>    proxy_header       = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | n/a | `number` | `5` | no |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | n/a | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_health_check_name"></a> [health\_check\_name](#output\_health\_check\_name) | The name of the health check. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the health check. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the health check. |
<!-- END_TF_DOCS -->
