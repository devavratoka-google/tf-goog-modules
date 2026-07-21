# Regional Target TCP Proxy Module

This submodule deploys a `google_compute_region_target_tcp_proxy` resource, which routes incoming TCP traffic from regional forwarding rules to regional backend services. Primarily used for Internal TCP Proxy Load Balancers and External Regional TCP Proxy Load Balancers.

## Usage

```hcl
module "tcp_proxy" {
  source          = "./modules/lb/tcp_routing"
  name            = "my-internal-tcp-proxy"
  region          = "us-central1"
  description     = "Target TCP Proxy for cross-cloud hybrid NEG"
  backend_service = module.region_backend_service["my-backend"].self_link
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the target TCP proxy. | `string` | n/a | yes |
| region | Region where the target TCP proxy resides. | `string` | n/a | yes |
| backend_service | The self_link or ID of the region backend service. | `string` | n/a | yes |
| description | An optional description of this resource. | `string` | `null` | no |
| proxy_header | Specifies the type of proxy header to append before sending data to the backend (NONE, PROXY_V1). | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the region target TCP proxy. |
| self_link | The URI of the created resource. |
