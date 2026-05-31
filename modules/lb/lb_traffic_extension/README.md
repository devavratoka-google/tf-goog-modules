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
| [google_network_services_lb_traffic_extension.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_services_lb_traffic_extension) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | A human-readable description of the resource. | `string` | `null` | no |
| <a name="input_extension_chains"></a> [extension\_chains](#input\_extension\_chains) | A list of extension chains containing match conditions and extensions. | <pre>list(object({<br/>    name = string<br/>    match_condition = object({<br/>      cel_expression = string<br/>    })<br/>    extensions = list(object({<br/>      name             = string<br/>      authority        = optional(string)<br/>      service          = string<br/>      timeout          = optional(string)<br/>      fail_open        = optional(bool)<br/>      forward_headers  = optional(list(string))<br/>      supported_events = optional(list(string))<br/>      metadata         = optional(map(string))<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_forwarding_rules"></a> [forwarding\_rules](#input\_forwarding\_rules) | A list of references to the forwarding rules to which this traffic extension is attached. | `list(string)` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the resource. | `map(string)` | `{}` | no |
| <a name="input_load_balancing_scheme"></a> [load\_balancing\_scheme](#input\_load\_balancing\_scheme) | The load balancing scheme of the traffic extension. E.g., INTERNAL\_MANAGED, EXTERNAL\_MANAGED. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the traffic extension. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the LbTrafficExtension resource. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the LbTrafficExtension resource. |
<!-- END_TF_DOCS -->
