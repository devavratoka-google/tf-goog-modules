# LB Traffic Extension Submodule

This submodule configures regional or global Load Balancer Traffic Extensions (`google_network_services_lb_traffic_extension`). It enables custom service callouts (Envoy/Service Extensions) to process request and response headers/payloads at the Load Balancer level.

## Usage

```hcl
module "lb_traffic_extension" {
  source                = "./modules/lb/lb_traffic_extension"
  name                  = "my-traffic-extension"
  location              = "us-central1"
  load_balancing_scheme = "INTERNAL_MANAGED"
  forwarding_rules      = [module.forwarding_rule.self_link]

  extension_chains = [
    {
      name = "chain-1"
      match_condition = {
        cel_expression = "request.host == 'example.com'"
      }
      extensions = [
        {
          name             = "ext-1"
          service          = "backend-service-self-link"
          supported_events = ["REQUEST_HEADERS"]
        }
      ]
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 7.0.0 |
| google-beta | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 7.0.0 |
| google-beta | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the LbTrafficExtension resource | `string` | n/a | yes |
| location | The location of the traffic extension | `string` | n/a | yes |
| load_balancing_scheme | The load balancing scheme of the traffic extension. E.g., INTERNAL_MANAGED, EXTERNAL_MANAGED | `string` | n/a | yes |
| forwarding_rules | A list of references to the forwarding rules to which this traffic extension is attached | `list(string)` | n/a | yes |
| extension_chains | A list of extension chains containing match conditions and extensions | <pre>list(object({<br>  name = string<br>  match_condition = object({<br>    cel_expression = string<br>  })<br>  extensions = list(object({<br>    name             = string<br>    authority        = optional(string)<br>    service          = string<br>    timeout          = optional(string)<br>    fail_open        = optional(bool)<br>    forward_headers  = optional(list(string))<br>    supported_events = optional(list(string))<br>    metadata         = optional(map(string))<br>  }))<br>}))</pre> | n/a | yes |
| description | A human-readable description of the resource | `string` | `null` | no |
| project | The ID of the project in which the resource belongs | `string` | `null` | no |
| labels | Labels to apply to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the LbTrafficExtension resource |
