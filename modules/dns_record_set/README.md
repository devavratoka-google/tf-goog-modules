# DNS Record Set Module

This module creates a Google Cloud DNS Record Set with type validation constraints.

## Usage

```hcl
module "dns_record_set" {
  source       = "./modules/dns_record_set"
  project      = "my-project-id"
  managed_zone = "my-zone"
  name         = "www.example.com."
  type         = "A"
  ttl          = 300
  rrdatas      = ["10.0.0.1"]
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
| [google_dns_record_set.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_managed_zone"></a> [managed\_zone](#input\_managed\_zone) | The name of the managed zone in which this record set will be created | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The DNS name of this record set, e.g. www.example.com. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project where the DNS resources will be created | `string` | `null` | no |
| <a name="input_rrdatas"></a> [rrdatas](#input\_rrdatas) | The string values for the record, e.g. IP addresses or CNAME targets | `list(string)` | `[]` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | The time-to-live of this record set (in seconds) | `number` | `300` | no |
| <a name="input_type"></a> [type](#input\_type) | The DNS record set type (A, AAAA, CNAME are allowed). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | An identifier for the resource with format projects/{{project}}/managedZones/{{managed_zone}}/rrsets/{{name}}/{{type}} |
| <a name="output_name"></a> [name](#output\_name) | The DNS name of this record set |
<!-- END_TF_DOCS -->
