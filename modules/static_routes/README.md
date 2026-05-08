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
| dest_range | The destination range of outgoing packets | `string` | n/a | yes |
| name | Name of the resource | `string` | n/a | yes |
| network | The network that this route applies to | `string` | n/a | yes |
| description | Description of this route | `string` | n/a | yes |
| priority | The priority of this route | `number` | n/a | yes |
| tags | A list of instance tags to which this route applies | `set(string)` | n/a | yes |
| next_hop_gateway | URL to a gateway that should handle matching packets | `string` | n/a | yes |
| next_hop_instance | URL to an instance that should handle matching packets | `string` | n/a | yes |
| next_hop_ip | Network IP address of an instance | `string` | n/a | yes |
| next_hop_vpn_tunnel | URL to a VpnTunnel that should handle matching packets | `string` | n/a | yes |
| next_hop_ilb | The IP address or URL to a forwarding rule | `string` | n/a | yes |
| project | The ID of the project in which the resource belongs | `string` | n/a | yes |
| next_hop_instance_zone | The zone of the instance specified in next_hop_instance | `string` | n/a | yes |
| resource_manager_tags | A set of key-value pairs for resource manager tags | `map(string)` | n/a | yes |

## Outputs

No outputs.
