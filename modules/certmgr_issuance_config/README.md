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

  project  = "my-project-id"
  location = "us-east4"
  name     = "internal-ca-config"

  certificate_authority_config = {
    certificate_authority_service_config = {
      ca_pool = "projects/my-project-id/locations/us-east4/caPools/internal-ca-pool"
    }
  }

  # Optional overrides — defaults shown
  key_algorithm              = "RSA_2048"
  lifetime                   = "2592000s"   # 30 days
  rotation_window_percentage = 66
}
```

## Notes

- `location` must match the region of the CA pool referenced in
  `certificate_authority_config`. Certificate Manager resources are regional.
- `lifetime` is expressed as a duration string ending in `s`
  (e.g. `"2592000s"` = 30 days, `"7776000s"` = 90 days).
- `rotation_window_percentage` controls when renewal is triggered before
  expiry. At the default of `66`, a 30-day cert renews after ~10 days.
- Changing `key_algorithm` or `lifetime` replaces the resource; existing
  certificates issued under the old config are unaffected.

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
| [google_certificate_manager_certificate_issuance_config.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate_issuance_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | A user-defined name of the certificate issuance config. | `string` | n/a | yes |
| <a name="input_certificate_authority_config"></a> [certificate\_authority\_config](#input\_certificate\_authority\_config) | The CA configuration for certificate issuance. | <pre>object({<br/>    certificate_authority_service_config = optional(object({<br/>      ca_pool = string<br/>    }), null)<br/>  })</pre> | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Certificate Manager location. | `string` | `"us-east4"` | no |
| <a name="input_description"></a> [description](#input\_description) | Optional description of the certificate issuance config. | `string` | `null` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | The key algorithm of the certificate. Possible values: `KEY_ALGORITHM_UNSPECIFIED`, `RSA_2048`, `ECDSA_P256`, `ECDSA_P384`. | `string` | `"RSA_2048"` | no |
| <a name="input_lifetime"></a> [lifetime](#input\_lifetime) | Lifetime of the issued certificate as a duration string (e.g. `"2592000s"` for 30 days). | `string` | `"2592000s"` | no |
| <a name="input_rotation_window_percentage"></a> [rotation\_window\_percentage](#input\_rotation\_window\_percentage) | Percentage of certificate lifetime at which renewal is triggered. Value between 1 and 99. | `number` | `66` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Key-value pair labels associated with the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Certificate Manager issuance config. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Certificate Manager issuance config. |
<!-- END_TF_DOCS -->
