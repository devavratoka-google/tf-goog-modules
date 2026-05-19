# Network Endpoint Group (NEG) Submodule

This submodule configures a Network Endpoint Group (NEG). It conditionally creates a Zonal NEG (for virtual machine workloads) and attaches endpoints, or a Regional Serverless NEG (for Cloud Run, Cloud Functions, or App Engine workloads) based on the `network_endpoint_type` parameter.

## Usage

### Zonal NEG (for VMs)
```hcl
module "zonal_neg" {
  source                = "./modules/lb/neg"
  name                  = "zonal-neg"
  network_endpoint_type = "GCE_VM_IP_PORT"
  network               = "my-vpc-self-link"
  subnetwork            = "my-subnet-self-link"
  zone                  = "us-central1-a"
  default_port          = 80

  endpoints = {
    "vm1" = {
      instance   = "my-vm-1"
      ip_address = "10.0.1.5"
      port       = 80
    }
  }
}
```

### Serverless NEG (for Cloud Run)
```hcl
module "serverless_neg" {
  source                = "./modules/lb/neg"
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  
  cloud_run = {
    service = "my-cloud-run-service"
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
| name | The name of the NEG resource | `string` | n/a | yes |
| network_endpoint_type | Type of network endpoints in this group. Use `SERVERLESS` for Serverless NEGs. | `string` | `"GCE_VM_IP_PORT"` | no |
| description | An optional description of the resource | `string` | `null` | no |
| network | The network this NEG belongs to | `string` | `null` | no |
| subnetwork | The subnetwork this NEG belongs to | `string` | `null` | no |
| zone | The zone of the zonal NEG | `string` | `null` | no |
| default_port | The default port used when the endpoint does not specify one | `number` | `null` | no |
| endpoints | A map of endpoints to attach to a Zonal NEG. Ignored for Serverless NEGs. | <pre>map(object({<br>  instance   = string<br>  ip_address = string<br>  port       = number<br>}))</pre> | `{}` | no |
| region | The region of the serverless NEG | `string` | `null` | no |
| cloud_run | Cloud Run service configuration for a Serverless NEG | <pre>object({<br>  service  = optional(string)<br>  tag      = optional(string)<br>  url_mask = optional(string)<br>})</pre> | `null` | no |
| cloud_function | Cloud Function configuration for a Serverless NEG | <pre>object({<br>  function = optional(string)<br>  url_mask = optional(string)<br>})</pre> | `null` | no |
| app_engine | App Engine configuration for a Serverless NEG | <pre>object({<br>  service  = optional(string)<br>  version  = optional(string)<br>  url_mask = optional(string)<br>})</pre> | `null` | no |

## Outputs

This module does not define any outputs.
