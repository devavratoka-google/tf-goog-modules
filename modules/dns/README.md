# DNS Module

This module creates a Google Cloud DNS Managed Zone and record sets.

## Usage

```hcl
module "dns" {
  source   = "./modules/dns"
  project  = "my-project-id"
  name     = "my-zone"
  dns_name = "example.com."
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label_governance"></a> [label\_governance](#module\_label\_governance) | ../label-governance | n/a |

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_managed_zone_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone_iam_member) | resource |
| [google_dns_record_set.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | A description of this managed zone | `string` | `"Managed by Terraform"` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | The DNS name of this managed zone, for example "example.com." | `string` | n/a | yes |
| <a name="input_forwarding_config"></a> [forwarding\_config](#input\_forwarding\_config) | The presence of this field indicates that outbound forwarding is enabled | <pre>object({<br/>    target_name_servers = list(object({<br/>      ipv4_address    = string<br/>      forwarding_path = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_member"></a> [member](#input\_member) | The member to add to the IAM policy | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the managed zone | `string` | n/a | yes |
| <a name="input_networks"></a> [networks](#input\_networks) | For private zones, the list of VPC networks that can see this zone | `list(string)` | `[]` | no |
| <a name="input_peering_config"></a> [peering\_config](#input\_peering\_config) | The presence of this field indicates that DNS peering is enabled | <pre>object({<br/>    target_network = string<br/>  })</pre> | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project where the DNS resources will be created | `string` | n/a | yes |
| <a name="input_record_sets"></a> [record\_sets](#input\_record\_sets) | Map of record sets to create in the zone | <pre>map(object({<br/>    name    = string<br/>    type    = string<br/>    ttl     = number<br/>    rrdatas = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | The zone's visibility: public or private | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_managed_zone_id"></a> [managed\_zone\_id](#output\_managed\_zone\_id) | The ID of the managed zone |
| <a name="output_managed_zone_name"></a> [managed\_zone\_name](#output\_managed\_zone\_name) | The name of the managed zone |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | The name servers of the managed zone. |
<!-- END_TF_DOCS -->
