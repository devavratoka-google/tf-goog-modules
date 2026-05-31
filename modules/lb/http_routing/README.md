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
| [google_compute_region_target_http_proxy.http](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_http_proxy) | resource |
| [google_compute_region_target_https_proxy.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_https_proxy) | resource |
| [google_compute_region_url_map.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_service"></a> [default\_service](#input\_default\_service) | The self\_link of the default region backend service. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_hosts"></a> [hosts](#input\_hosts) | List of host headers to match (e.g., ['internal-lb.example.com']) | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates) | n/a | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the target HTTP proxy. |
| <a name="output_url_map_id"></a> [url\_map\_id](#output\_url\_map\_id) | The ID of the URL map. |
<!-- END_TF_DOCS -->
