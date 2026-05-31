# Google KMS Terraform Module

Simple Cloud KMS module that allows managing a keyring, zero or more keys in the keyring, and IAM role bindings on individual keys.

The resources/services/activations/deletions that this module will create/trigger are:

- Create a KMS keyring in the provided project
- Create zero or more keys in the keyring
- Create IAM role bindings for owners, encrypters, decrypters

## Compatibility
This module is meant for use with Terraform v1.3+ and tested using Terraform v1.10+.
 If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v1.2.0](https://registry.terraform.io/modules/terraform-google-modules/-kms/google/v1.2.0).

## Usage

Basic usage of this module is as follows:

```hcl
module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 4.1"

  project_id         = "<PROJECT ID>"
  location           = "europe"
  keyring            = "sample-keyring"
  keys               = ["foo", "spam"]
  set_owners_for     = ["foo", "spam"]
  owners = [
    "group:one@example.com,group:two@example.com",
    "group:one@example.com",
  ]
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
Copyright 2018 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_kms_crypto_key.key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_kms_crypto_key.key_ephemeral](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_kms_crypto_key_iam_binding.decrypters](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_binding) | resource |
| [google_kms_crypto_key_iam_binding.encrypters](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_binding) | resource |
| [google_kms_crypto_key_iam_binding.owners](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_binding) | resource |
| [google_kms_key_ring.key_ring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_crypto_key_backend"></a> [crypto\_key\_backend](#input\_crypto\_key\_backend) | (Optional) The resource name of the backend environment associated with all CryptoKeyVersions within this CryptoKey. The resource name is in the format 'projects//locations//ekmConnections/*' and only applies to 'EXTERNAL\_VPC' keys. | `string` | `null` | no |
| <a name="input_decrypters"></a> [decrypters](#input\_decrypters) | List of comma-separated owners for each key declared in set\_decrypters\_for. | `list(string)` | `[]` | no |
| <a name="input_encrypters"></a> [encrypters](#input\_encrypters) | List of comma-separated owners for each key declared in set\_encrypters\_for. | `list(string)` | `[]` | no |
| <a name="input_import_only"></a> [import\_only](#input\_import\_only) | Whether these keys may contain imported versions only. | `bool` | `false` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs. | `string` | `"GOOGLE_SYMMETRIC_ENCRYPTION"` | no |
| <a name="input_key_destroy_scheduled_duration"></a> [key\_destroy\_scheduled\_duration](#input\_key\_destroy\_scheduled\_duration) | Set the period of time that versions of keys spend in the DESTROY\_SCHEDULED state before transitioning to DESTROYED. | `string` | `null` | no |
| <a name="input_key_protection_level"></a> [key\_protection\_level](#input\_key\_protection\_level) | The protection level to use when creating a version based on this template. Default value: "SOFTWARE" Possible values: ["SOFTWARE", "HSM", "EXTERNAL", "EXTERNAL\_VPC"] | `string` | `"SOFTWARE"` | no |
| <a name="input_key_rotation_period"></a> [key\_rotation\_period](#input\_key\_rotation\_period) | Generate a new key every time this period passes. | `string` | `"7776000s"` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | Keyring name. | `string` | n/a | yes |
| <a name="input_keys"></a> [keys](#input\_keys) | Key names. | `list(string)` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels, provided as a map | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Location for the keyring. | `string` | n/a | yes |
| <a name="input_owners"></a> [owners](#input\_owners) | List of comma-separated owners for each key declared in set\_owners\_for. | `list(string)` | `[]` | no |
| <a name="input_prevent_destroy"></a> [prevent\_destroy](#input\_prevent\_destroy) | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | `true` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where the keyring will be created. | `string` | n/a | yes |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The immutable purpose of the CryptoKey. Default value is ENCRYPT\_DECRYPT. See purpose reference (https://cloud.google.com/kms/docs/reference/rest/v1/projects.locations.keyRings.cryptoKeys#CryptoKeyPurpose) for possible inputs. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_set_decrypters_for"></a> [set\_decrypters\_for](#input\_set\_decrypters\_for) | Name of keys for which decrypters will be set. | `list(string)` | `[]` | no |
| <a name="input_set_encrypters_for"></a> [set\_encrypters\_for](#input\_set\_encrypters\_for) | Name of keys for which encrypters will be set. | `list(string)` | `[]` | no |
| <a name="input_set_owners_for"></a> [set\_owners\_for](#input\_set\_owners\_for) | Name of keys for which owners will be set. | `list(string)` | `[]` | no |
| <a name="input_skip_initial_version_creation"></a> [skip\_initial\_version\_creation](#input\_skip\_initial\_version\_creation) | If set to true, the request will create CryptoKeys without any CryptoKeyVersions. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_id_list"></a> [key\_id\_list](#output\_key\_id\_list) | The list of the crypto key IDs. |
| <a name="output_keyring"></a> [keyring](#output\_keyring) | Self link of the keyring. |
| <a name="output_keyring_name"></a> [keyring\_name](#output\_keyring\_name) | Name of the keyring. |
| <a name="output_keyring_resource"></a> [keyring\_resource](#output\_keyring\_resource) | Keyring resource. |
| <a name="output_keys"></a> [keys](#output\_keys) | Map of key name => key self link. |
<!-- END_TF_DOCS -->
