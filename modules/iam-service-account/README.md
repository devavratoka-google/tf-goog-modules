# IAM Service Account (local)

Local copy of the [Cloud Foundation Fabric](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric)
`iam-service-account` module, pinned at release **v55.1.0** (same version
used by the [`cloud-run-v2`](../cloud-run-v2) module in this repo).

Allows creating a service account (or reusing an existing one) and managing:

- Authoritative / additive IAM bindings **on** the service account resource
  (`iam`, `iam_by_principals`, `iam_bindings`, `iam_bindings_additive`,
  `iam_by_principals_additive`).
- Additive IAM bindings **granted to** this service account on external
  resources: project, folder, organization, billing account, GCS bucket,
  another service account, and (local extension) BigQuery dataset.

## Use case in this repo

When a GCE VM is created with a service account attached (for example by the
[`ilbanh`](../ilbanh) module, which receives `service_account_email` as
input), this module is used to grant that SA the project/dataset/bucket roles
it needs at runtime (e.g. `roles/bigquery.dataViewer`,
`roles/storage.objectViewer`) without recreating the SA.

```hcl
module "vm_sa_iam" {
  source = "./modules/iam-service-account"

  # Reuse the SA already created/used by the VM
  name = "vm-runtime@my-project.iam.gserviceaccount.com"
  service_account_reuse = {
    use_data_source = false
  }

  iam_project_roles = {
    "my-project" = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
    ]
  }

  iam_bigquery_dataset_roles = {
    "my-project/analytics" = [
      "roles/bigquery.dataViewer",
    ]
  }

  iam_storage_roles = {
    "my-data-bucket" = [
      "roles/storage.objectViewer",
    ]
  }
}
```

## Upstream and local divergences

Upstream:
[`GoogleCloudPlatform/cloud-foundation-fabric/modules/iam-service-account`](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric/tree/v55.1.0/modules/iam-service-account)
at tag `v55.1.0`.

Local-only changes:

1. **`versions.tf`**: `required_providers` removed. Providers are inherited
   from the root [`providers.tf`](../../providers.tf), which is the single
   source of truth for provider versions across the repo (same pattern as
   [`modules/gcs/versions.tf`](../gcs/versions.tf) and
   [`modules/cloud-run-v2/versions.tf`](../cloud-run-v2/versions.tf)).
   `provider_meta.module_name` is preserved so fabric usage telemetry stays
   accurate.
2. **`iam-bigquery.tf` + `iam_bigquery_dataset_roles` variable** (new):
   adds support for granting roles to this SA on BigQuery datasets via
   `google_bigquery_dataset_iam_member`. Upstream `iam-service-account` does
   not cover BQ datasets directly. Keys use the `"project_id/dataset_id"`
   format, validated at variable level.

Everything else (`main.tf`, `iam.tf`, `outputs.tf`, `variables.tf`,
`variables-iam.tf`) is an unmodified copy of the upstream sources to keep
future sync straightforward.

## Reusing an existing SA

Set `service_account_reuse = { use_data_source = false }` and pass the full
SA email as `name`. In this mode no `google_service_account` resource is
created and `project_id` can be omitted (it is inferred from the email).

For more details on the `iam_*` variables semantics, refer to the
[upstream README](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric/blob/v55.1.0/modules/iam-service-account/README.md).

<!-- BEGIN_TF_DOCS -->
Copyright 2025 Google LLC

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset_iam_member.bigquery-dataset-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_iam_member) | resource |
| [google_billing_account_iam_member.billing-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_account_iam_member) | resource |
| [google_folder_iam_member.folder-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_organization_iam_member.organization-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_project_iam_member.project-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.authoritative](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_member.additive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_storage_bucket_iam_member.bucket-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_tags_tag_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_binding) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | External context used in replacements. | <pre>object({<br/>    condition_vars      = optional(map(map(string)), {})<br/>    custom_roles        = optional(map(string), {})<br/>    folder_ids          = optional(map(string), {})<br/>    iam_principals      = optional(map(string), {})<br/>    project_ids         = optional(map(string), {})<br/>    service_account_ids = optional(map(string), {})<br/>    storage_buckets     = optional(map(string), {})<br/>    tag_values          = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_create_ignore_already_exists"></a> [create\_ignore\_already\_exists](#input\_create\_ignore\_already\_exists) | If set to true, skip service account creation if a service account with the same email already exists. | `bool` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Optional description. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the service account to create. | `string` | `"Terraform-managed."` | no |
| <a name="input_iam"></a> [iam](#input\_iam) | IAM bindings in {ROLE => [MEMBERS]} format. | `map(list(string))` | `{}` | no |
| <a name="input_iam_bigquery_dataset_roles"></a> [iam\_bigquery\_dataset\_roles](#input\_iam\_bigquery\_dataset\_roles) | BigQuery dataset roles granted to this service account, by 'project\_id/dataset\_id' key. Non-authoritative. | `map(list(string))` | `{}` | no |
| <a name="input_iam_billing_roles"></a> [iam\_billing\_roles](#input\_iam\_billing\_roles) | Billing account roles granted to this service account, by billing account id. Non-authoritative. | `map(list(string))` | `{}` | no |
| <a name="input_iam_bindings"></a> [iam\_bindings](#input\_iam\_bindings) | Authoritative IAM bindings in {KEY => {role = ROLE, members = [], condition = {}}}. Keys are arbitrary. | <pre>map(object({<br/>    members = list(string)<br/>    role    = string<br/>    condition = optional(object({<br/>      expression  = string<br/>      title       = string<br/>      description = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_iam_bindings_additive"></a> [iam\_bindings\_additive](#input\_iam\_bindings\_additive) | Individual additive IAM bindings. Keys are arbitrary. | <pre>map(object({<br/>    member = string<br/>    role   = string<br/>    condition = optional(object({<br/>      expression  = string<br/>      title       = string<br/>      description = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_iam_by_principals"></a> [iam\_by\_principals](#input\_iam\_by\_principals) | Authoritative IAM binding in {PRINCIPAL => [ROLES]} format. Principals need to be statically defined to avoid errors. Merged internally with the `iam` variable. | `map(list(string))` | `{}` | no |
| <a name="input_iam_by_principals_additive"></a> [iam\_by\_principals\_additive](#input\_iam\_by\_principals\_additive) | Additive IAM binding in {PRINCIPAL => [ROLES]} format. Principals need to be statically defined to avoid errors. Merged internally with the `iam_bindings_additive` variable. | `map(list(string))` | `{}` | no |
| <a name="input_iam_folder_roles"></a> [iam\_folder\_roles](#input\_iam\_folder\_roles) | Folder roles granted to this service account, by folder id. Non-authoritative. | `map(list(string))` | `{}` | no |
| <a name="input_iam_organization_roles"></a> [iam\_organization\_roles](#input\_iam\_organization\_roles) | Organization roles granted to this service account, by organization id. Non-authoritative. | `map(list(string))` | `{}` | no |
| <a name="input_iam_project_roles"></a> [iam\_project\_roles](#input\_iam\_project\_roles) | Project roles granted to this service account, by project id. | `map(list(string))` | `{}` | no |
| <a name="input_iam_sa_roles"></a> [iam\_sa\_roles](#input\_iam\_sa\_roles) | Service account roles granted to this service account, by service account name. | `map(list(string))` | `{}` | no |
| <a name="input_iam_storage_roles"></a> [iam\_storage\_roles](#input\_iam\_storage\_roles) | Storage roles granted to this service account, by bucket name. | `map(list(string))` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the service account to create. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service account names. | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where service account will be created. This can be left null when reusing service accounts. | `string` | `null` | no |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | Project number of var.project\_id. Set this to avoid permadiffs when creating tag bindings. This can be left null when reusing service accounts and tags are not used. | `string` | `null` | no |
| <a name="input_service_account_reuse"></a> [service\_account\_reuse](#input\_service\_account\_reuse) | Reuse existing service account if not null. Data source can be forced disabled if tag bindings are not used, or unique id is set. | <pre>object({<br/>    use_data_source = optional(bool, true)<br/>    attributes = optional(object({<br/>      project_number = number<br/>      unique_id      = string<br/>    }))<br/>    universe = optional(object({<br/>      prefix = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_tag_bindings"></a> [tag\_bindings](#input\_tag\_bindings) | Tag bindings for this service accounts, in key => tag value id format. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_email"></a> [email](#output\_email) | Service account email. |
| <a name="output_iam_email"></a> [iam\_email](#output\_iam\_email) | IAM-format service account email. |
| <a name="output_id"></a> [id](#output\_id) | Fully qualified service account id. |
| <a name="output_name"></a> [name](#output\_name) | Service account name. |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account resource. |
| <a name="output_unique_id"></a> [unique\_id](#output\_unique\_id) | Fully qualified service account id. |
<!-- END_TF_DOCS -->
