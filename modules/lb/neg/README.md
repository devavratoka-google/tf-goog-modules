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
| [google_compute_network_endpoint.zonal_endpoints](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_endpoint) | resource |
| [google_compute_network_endpoint_group.zonal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_endpoint_group) | resource |
| [google_compute_region_network_endpoint_group.serverless](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_engine"></a> [app\_engine](#input\_app\_engine) | n/a | <pre>object({<br/>    service  = optional(string)<br/>    version  = optional(string)<br/>    url_mask = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_cloud_function"></a> [cloud\_function](#input\_cloud\_function) | n/a | <pre>object({<br/>    function = optional(string)<br/>    url_mask = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_cloud_run"></a> [cloud\_run](#input\_cloud\_run) | n/a | <pre>object({<br/>    service  = optional(string)<br/>    tag      = optional(string)<br/>    url_mask = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_default_port"></a> [default\_port](#input\_default\_port) | n/a | `number` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | A map of endpoints to attach to a Zonal NEG. Ignored for Serverless NEGs. | <pre>map(object({<br/>    instance   = string<br/>    ip_address = string<br/>    port       = number<br/>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | n/a | `string` | `null` | no |
| <a name="input_network_endpoint_type"></a> [network\_endpoint\_type](#input\_network\_endpoint\_type) | n/a | `string` | `"GCE_VM_IP_PORT"` | no |
| <a name="input_region"></a> [region](#input\_region) | Specific to Regional Serverless NEGs | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | n/a | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Specific to Zonal NEGs | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the network endpoint group. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the network endpoint group. |
<!-- END_TF_DOCS -->
