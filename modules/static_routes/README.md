# Static Routes Module

This module creates a Google Cloud Compute Route.

## Usage

```hcl
module "static_routes" {
  source      = "./modules/static_routes"
  dest_range  = "10.0.0.0/8"
  name        = "my-route"
  network     = "my-vpc-self-link"
  description = "My static route"
  # ... other required variables
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
| [google_compute_route.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | n/a | yes |
| <a name="input_dest_range"></a> [dest\_range](#input\_dest\_range) | The destination range of outgoing packets that this route applies to. Only IPv4 is supported. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression 'a-z?' which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The network that this route applies to. | `string` | n/a | yes |
| <a name="input_next_hop_gateway"></a> [next\_hop\_gateway](#input\_next\_hop\_gateway) | URL to a gateway that should handle matching packets. | `string` | n/a | yes |
| <a name="input_next_hop_ilb"></a> [next\_hop\_ilb](#input\_next\_hop\_ilb) | The IP address or URL to a forwarding rule of type loadBalancingScheme=INTERNAL that should handle matching packets. With the GA provider you can only specify the forwarding rule as a partial or full URL. | `string` | n/a | yes |
| <a name="input_next_hop_instance"></a> [next\_hop\_instance](#input\_next\_hop\_instance) | URL to an instance that should handle matching packets. | `string` | n/a | yes |
| <a name="input_next_hop_instance_zone"></a> [next\_hop\_instance\_zone](#input\_next\_hop\_instance\_zone) | (Optional when next\_hop\_instance is specified) The zone of the instance specified in next\_hop\_instance. Omit if next\_hop\_instance is specified as a URL. | `string` | n/a | yes |
| <a name="input_next_hop_ip"></a> [next\_hop\_ip](#input\_next\_hop\_ip) | Network IP address of an instance that should handle matching packets. | `string` | n/a | yes |
| <a name="input_next_hop_vpn_tunnel"></a> [next\_hop\_vpn\_tunnel](#input\_next\_hop\_vpn\_tunnel) | URL to a VpnTunnel that should handle matching packets. | `string` | n/a | yes |
| <a name="input_priority"></a> [priority](#input\_priority) | The priority of this route. Priority is used to break ties in cases where there is more than one matching route of equal prefix length. In the case of two routes with equal prefix length, the one with the lowest-numbered priority value wins. Default value is 1000. Valid range is 0 through 65535. | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| <a name="input_resource_manager_tags"></a> [resource\_manager\_tags](#input\_resource\_manager\_tags) | A set of key-value pairs to be used as resource manager tags. These tags are not applied to the underlying API resource, but are stored in the state file and can be used for filtering and other purposes. | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of instance tags to which this route applies. | `set(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
