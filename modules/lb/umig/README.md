# Unmanaged Instance Group (UMIG) Submodule

This submodule configures a Google Compute Unmanaged Instance Group (UMIG) and lists its static instances and named ports.

## Usage

```hcl
module "umig" {
  source    = "./modules/lb/umig"
  name      = "my-umig"
  zone      = "us-central1-a"
  network   = "my-vpc-self-link"
  instances = ["my-vm-instance-self-link"]

  named_ports = [
    {
      name = "http"
      port = 80
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
| name | The name of the instance group | `string` | n/a | yes |
| zone | The GCP zone where the instance group resides | `string` | n/a | yes |
| description | An optional description of the resource | `string` | `null` | no |
| network | The network this instance group belongs to | `string` | `null` | no |
| instances | Set of instance URLs/Self Links that belong to this instance group | `set(string)` | `[]` | no |
| named_ports | List of named ports to map name to a port number | <pre>list(object({<br>  name = string<br>  port = number<br>}))</pre> | `[]` | no |

## Outputs

This submodule does not define any outputs.
