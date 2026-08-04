# Certificate Manager Regional Certificate Module (`certmgr_certificate`)

Creates a regional [Certificate Manager Certificate](https://cloud.google.com/certificate-manager/docs/reference/rest/v1/projects.locations.certificates) (`google_certificate_manager_certificate`) using a Certificate Authority Service (CAS) CA Pool via a regional Certificate Issuance Config.

## Overview

This module automatically discovers the regional Certificate Issuance Config in the respective GCP project using a Terraform `data` source (`data.google_certificate_manager_certificate_issuance_config`).

### Naming Convention
By default, the issuance config resource name is resolved using the customer convention:
`<project-id>-issuance-config-<region>`

Where `<region>` is the 4-character short region name (e.g., `use4` for `us-east4`, `usw1` for `us-west1`). For example:
* **Project**: `project-abc-01`
* **Location**: `us-east4`
* **Resolved Issuance Config Name**: `project-abc-01-issuance-config-use4`

The module includes a built-in mapping for standard GCP regions to their 4-character short codes, and also supports overriding via the `short_region` or `issuance_config_name` input variables.

## Usage

```hcl
module "regional_cert" {
  source = "./modules/certmgr_certificate"

  name        = "my-app-regional-cert"
  project     = "project-abc-01"
  location    = "us-east4"
  domains     = ["api.example.com"]
  description = "Regional API Certificate in us-east4"

  labels = {
    environment = "prod"
    app         = "api"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label_governance"></a> [label\_governance](#module\_label\_governance) | ../label-governance | n/a |

## Resources

| Name | Type |
|------|------|
| [google_certificate_manager_certificate.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | A user-specified name for the certificate. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project where the certificate and issuance config reside. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The regional location where the certificate will be created (e.g., `'us-east4'`, `'us-west1'`). | `string` | n/a | yes |
| <a name="input_domains"></a> [domains](#input\_domains) | The list of domains for which this managed certificate should be issued. | `list(string)` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | An optional description of the certificate. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to assign to the certificate. | `map(string)` | `{}` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope of the certificate (e.g., `'DEFAULT'`, `'EDGE_CACHE'`, `'ALL_REGIONS'`). Defaults to null for regional default. | `string` | `null` | no |
| <a name="input_dns_authorizations"></a> [dns\_authorizations](#input\_dns\_authorizations) | The DNS authorizations to use for this managed certificate, if applicable. | `list(string)` | `null` | no |
| <a name="input_short_region"></a> [short\_region](#input\_short\_region) | Optional override for the 4-character region code (e.g., `'use4'`, `'usw1'`). If omitted, automatically derived from location. | `string` | `null` | no |
| <a name="input_issuance_config_name"></a> [issuance\_config\_name](#input\_issuance\_config\_name) | Optional override for the Certificate Manager Issuance Config resource name. If omitted, defaults to `'<project>-issuance-config-<short_region>'`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The an identifier for the resource with format `projects/{{project}}/locations/{{location}}/certificates/{{name}}`. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Certificate Manager certificate. |
| <a name="output_location"></a> [location](#output\_location) | The location of the Certificate Manager certificate. |
| <a name="output_project"></a> [project](#output\_project) | The project ID of the Certificate Manager certificate. |
| <a name="output_issuance_config_id"></a> [issuance\_config\_id](#output\_issuance\_config\_id) | The ID of the Certificate Manager Issuance Config resolved by convention. |
| <a name="output_issuance_config_name"></a> [issuance\_config\_name](#output\_issuance\_config\_name) | The name of the Certificate Manager Issuance Config resolved by convention. |
<!-- END_TF_DOCS -->
