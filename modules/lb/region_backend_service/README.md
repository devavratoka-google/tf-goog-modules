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
| name | Name of the backend service | `string` | n/a | yes |
| region | The GCP region for the backend service | `string` | n/a | yes |
| description | An optional description of the resource | `string` | `null` | no |
| load_balancing_scheme | The load balancing scheme. e.g., INTERNAL, INTERNAL_MANAGED, EXTERNAL, EXTERNAL_MANAGED. | `string` | `"INTERNAL_MANAGED"` | no |
| protocol | The protocol of the backend service. e.g., HTTP, HTTPS, HTTP2, TCP, SSL, GRPC. | `string` | `"HTTP"` | no |
| port_name | A user-defined name of the port on the backend group | `string` | `"http"` | no |
| timeout_sec | How many seconds to wait for the backend before considering it a failed request | `number` | `30` | no |
| connection_draining_timeout_sec | Time period (in seconds) during which TCP connections are drained | `number` | `0` | no |
| health_checks | List of self_links of health checks | `list(string)` | `[]` | no |
| enable_cdn | If true, enable Cloud CDN for this backend service | `bool` | `false` | no |
| log_config | Logging configuration | <pre>object({<br>  enable      = optional(bool, false)<br>  sample_rate = optional(number, 1.0)<br>})</pre> | `null` | no |
| backends | A list of backends (Instance Groups or NEGs) attached to this service. | <pre>list(object({<br>  group                        = string<br>  balancing_mode               = optional(string)<br>  capacity_scaler              = optional(number)<br>  description                  = optional(string)<br>  failover                     = optional(bool)<br>  max_connections              = optional(number)<br>  max_connections_per_endpoint = optional(number)<br>  max_connections_per_instance = optional(number)<br>  max_rate                     = optional(number)<br>  max_rate_per_endpoint        = optional(number)<br>  max_rate_per_instance        = optional(number)<br>  max_utilization              = optional(number)<br>}))</pre> | `[]` | no |

## Outputs

This submodule does not define any outputs.
