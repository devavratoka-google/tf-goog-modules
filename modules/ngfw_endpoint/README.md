# Next-Generation Firewall (NGFW) Endpoint Module

This module configures a Google Cloud Network Security Firewall Endpoint and its associated Network Security Firewall Endpoint Association resources.

## Usage

```hcl
module "ngfw_endpoint" {
  source             = "./modules/ngfw_endpoint"
  name               = "my-firewall-endpoint"
  parent             = "organizations/1234567890"
  location           = "us-central1-a"
  billing_project_id = "my-billing-project-id"
  labels             = { env = "production" }

  fw_ep_associations = {
    "assoc-1" = {
      fw_ip_association_parent   = "projects/my-vpc-project-id"
      network                    = "my-vpc-self-link"
      fw_ip_association_location = "us-central1-a"
      fw_ep_association_labels   = { env = "production" }
      tls_inspection_policy      = "projects/my-vpc-project-id/locations/us-central1-a/tlsInspectionPolicies/my-tls-policy"
      disabled                   = false
    }
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
| [google_network_security_firewall_endpoint.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_firewall_endpoint) | resource |
| [google_network_security_firewall_endpoint_association.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_firewall_endpoint_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_project_id"></a> [billing\_project\_id](#input\_billing\_project\_id) | (Required) Project to bill on endpoint uptime usage. | `string` | n/a | yes |
| <a name="input_fw_ep_associations"></a> [fw\_ep\_associations](#input\_fw\_ep\_associations) | n/a | <pre>map(object({<br/>    fw_ip_association_parent   = string<br/>    network                    = string<br/>    fw_ip_association_location = string<br/>    fw_ep_association_labels   = map(string)<br/>    tls_inspection_policy      = string<br/>    disabled                   = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of key/value label pairs to assign to the resource. | `map(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location (zone) of the firewall endpoint. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the firewall endpoint resource. | `string` | n/a | yes |
| <a name="input_parent"></a> [parent](#input\_parent) | (Required) The name of the parent this firewall endpoint belongs to. Format: organizations/{organization\_id}. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_associations"></a> [associations](#output\_associations) | A map of firewall endpoint associations created. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the created firewall endpoint. |
| <a name="output_name"></a> [name](#output\_name) | The name of the created firewall endpoint. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the created firewall endpoint. |
<!-- END_TF_DOCS -->
