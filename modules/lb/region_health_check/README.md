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

## Requirements

| Name | Version |
|------|---------|
| terraform | > 1.5.0 |
| google | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the health check | `string` | n/a | yes |
| region | The region of the health check | `string` | n/a | yes |
| description | An optional description of the resource | `string` | `null` | no |
| check_interval_sec | How often (in seconds) to send a health check query | `number` | `5` | no |
| timeout_sec | How long (in seconds) to wait before claiming failure | `number` | `5` | no |
| healthy_threshold | Consecutive successes required to mark backend as healthy | `number` | `2` | no |
| unhealthy_threshold | Consecutive failures required to mark backend as unhealthy | `number` | `2` | no |
| log_config | Logging configuration | <pre>object({<br>  enable = optional(bool, false)<br>})</pre> | `null` | no |
| tcp_health_check | TCP health check configuration details | <pre>object({<br>  port               = optional(number)<br>  port_specification = optional(string)<br>  port_name          = optional(string)<br>  request            = optional(string)<br>  response           = optional(string)<br>  proxy_header       = optional(string)<br>})</pre> | `null` | no |
| http_health_check | HTTP health check configuration details | <pre>object({<br>  port               = optional(number)<br>  port_specification = optional(string)<br>  port_name          = optional(string)<br>  host               = optional(string)<br>  request_path       = optional(string)<br>  response           = optional(string)<br>  proxy_header       = optional(string)<br>})</pre> | `null` | no |
| https_health_check | HTTPS health check configuration details | <pre>object({<br>  port               = optional(number)<br>  port_specification = optional(string)<br>  port_name          = optional(string)<br>  host               = optional(string)<br>  request_path       = optional(string)<br>  response           = optional(string)<br>  proxy_header       = optional(string)<br>})</pre> | `null` | no |
| http2_health_check | HTTP2 health check configuration details | <pre>object({<br>  port               = optional(number)<br>  port_specification = optional(string)<br>  port_name          = optional(string)<br>  host               = optional(string)<br>  request_path       = optional(string)<br>  response           = optional(string)<br>  proxy_header       = optional(string)<br>})</pre> | `null` | no |
| ssl_health_check | SSL health check configuration details | <pre>object({<br>  port               = optional(number)<br>  port_specification = optional(string)<br>  port_name          = optional(string)<br>  request            = optional(string)<br>  response           = optional(string)<br>  proxy_header       = optional(string)<br>})</pre> | `null` | no |
| grpc_health_check | gRPC health check configuration details | <pre>object({<br>  port               = optional(number)<br>  port_specification = optional(string)<br>  port_name          = optional(string)<br>  grpc_service_name  = optional(string)<br>})</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| health_check_name | The name of the created regional health check |
