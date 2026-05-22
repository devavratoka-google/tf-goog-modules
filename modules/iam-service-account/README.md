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
