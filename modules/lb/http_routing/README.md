# HTTP Routing Submodule

This submodule configures regional HTTP/HTTPS routing. It creates a regional URL Map, and conditionally creates either a Target HTTP Proxy (if no SSL certificates are supplied) or a Target HTTPS Proxy (if SSL certificates are supplied).

## Usage

```hcl
module "http_routing" {
  source           = "./modules/lb/http_routing"
  name             = "my-http-routing"
  region           = "us-central1"
  default_service  = "my-backend-service-self-link"
  hosts            = ["internal-lb.example.com"]
  ssl_certificates = ["my-ssl-cert-self-link"]
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
| name | The name of the URL map and target proxy | `string` | n/a | yes |
| region | The region of the routing resources | `string` | n/a | yes |
| description | An optional description of the URL map | `string` | `null` | no |
| default_service | The self_link of the default region backend service | `string` | n/a | yes |
| ssl_certificates | List of SSL certificate self_links. If provided, an HTTPS target proxy is created; otherwise, an HTTP target proxy is created. | `list(string)` | `[]` | no |
| hosts | List of host headers to match (e.g., `["internal-lb.example.com"]`) | `list(string)` | `[]` | no |

## Outputs

This module does not define any outputs.
