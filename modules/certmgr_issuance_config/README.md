# Certificate Manager Issuance Config

Creates a [Certificate Manager Certificate Issuance Config](https://cloud.google.com/certificate-manager/docs/reference/rest/v1/projects.locations.certificateIssuanceConfigs)
(`google_certificate_manager_certificate_issuance_config`) that controls how
managed certificates are issued — key algorithm, lifetime, rotation window,
and which Certificate Authority pool to use.

This resource is typically paired with a Certificate Manager `CertificateMap`
and individual `Certificate` resources that reference this issuance config.

## Usage

```hcl
module "cert_issuance_config" {
  source = "./modules/certmgr_issuance_config"
}
```

## Notes

- This module auto-discovers all active projects in your GCP organization.
- It provisions a Certificate Manager Issuance Config for each project in two regions:
  - **Region 1 (us-east4)**: using `projects/nyl-pr-ssvcs-pki-01/locations/us-east4/caPools/ssvcs-pki-01-nonprod-poo1-01`
  - **Region 2 (us-west1)**: using `projects/sjc-pr-ssvcs-pki-01/locations/us-west1/caPools/ssvcs-pki-01-nonprod-poo1-01`
- It binds `roles/privateca.certificateRequester` for each project's Certificate Manager service agent to the respective CA Pool.

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

No modules.

## Resources

| Name | Type |
|------|------|
| [google_certificate_manager_certificate_issuance_config.this_use4](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate_issuance_config) | resource |
| [google_certificate_manager_certificate_issuance_config.this_usw1](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate_issuance_config) | resource |
| [google_privateca_ca_pool_iam_member.certrequester_use4](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/privateca_ca_pool_iam_member) | resource |
| [google_privateca_ca_pool_iam_member.certrequester_usw1](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/privateca_ca_pool_iam_member) | resource |
| [google_projects.all_org_projects](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/projects) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_project_ids"></a> [all\_project\_ids](#output\_all\_project\_ids) | The list of all active project IDs retrieved. |
| <a name="output_id_use4"></a> [id\_use4](#output\_id\_use4) | The IDs of the Certificate Manager issuance configs in us-east4. |
| <a name="output_id_usw1"></a> [id\_usw1](#output\_id\_usw1) | The IDs of the Certificate Manager issuance configs in us-west1. |
| <a name="output_name_use4"></a> [name\_use4](#output\_name\_use4) | The names of the Certificate Manager issuance configs in us-east4. |
| <a name="output_name_usw1"></a> [name\_usw1](#output\_name\_usw1) | The names of the Certificate Manager issuance configs in us-west1. |
<!-- END_TF_DOCS -->
