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
| name | The name of the forwarding rule | `string` | n/a | yes |
| region | The region of the forwarding rule | `string` | n/a | yes |
| description | An optional description of this resource | `string` | `null` | no |
| network | The network this forwarding rule belongs to | `string` | `null` | no |
| subnetwork | The subnetwork this forwarding rule belongs to | `string` | `null` | no |
| ip_address | The IP address that this forwarding rule serves | `string` | `null` | no |
| ip_protocol | The IP protocol that this forwarding rule serves. e.g., TCP, UDP, ESP, AH, SCTP, ICMP, L3_DEFAULT | `string` | `null` | no |
| ports | List of ports to forward. Only used if `port_range` is empty. | `list(string)` | `[]` | no |
| port_range | The port range to forward. | `string` | `null` | no |
| backend_service | The backend service target of this forwarding rule. | `string` | `null` | no |
| target | The target resource (e.g. target HTTP proxy, target HTTPS proxy) of this forwarding rule. | `string` | `null` | no |
| load_balancing_scheme | The type of load balancing this forwarding rule is used for. e.g., INTERNAL, EXTERNAL, INTERNAL_MANAGED, EXTERNAL_MANAGED. | `string` | `"INTERNAL"` | no |
| allow_global_access | If true, clients can access this internal load balancer from any region. | `bool` | `null` | no |
| network_tier | The networking tier used for configuring this forwarding rule. | `string` | `null` | no |
| labels | Labels to apply to the forwarding rule. | `map(string)` | `{}` | no |
| service_directory_registrations | Service Directory registration configuration. | <pre>object({<br>  namespace = optional(string)<br>  service   = optional(string)<br>})</pre> | `null` | no |

## Outputs

This module does not define any outputs.
