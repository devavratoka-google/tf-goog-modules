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
| [google_compute_instance_group.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | n/a | `set(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_named_ports"></a> [named\_ports](#input\_named\_ports) | List of named ports to map name to a port number | <pre>list(object({<br/>    name = string<br/>    port = number<br/>  }))</pre> | `[]` | no |
| <a name="input_network"></a> [network](#input\_network) | n/a | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the unmanaged instance group. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the unmanaged instance group. |
<!-- END_TF_DOCS -->
