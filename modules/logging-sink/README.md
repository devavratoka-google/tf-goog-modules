# Logging Sink

Creates a Cloud Logging project sink (`google_logging_project_sink`) that
routes log entries to a destination such as BigQuery, Cloud Storage, or
Pub/Sub. Always uses `unique_writer_identity = true` so the sink gets its own
service account, which must be granted IAM access on the destination.

The `writer_identity` output exposes that service account so it can be wired
directly into downstream IAM modules.

## Usage

```hcl
# Sink to BigQuery
module "audit_sink" {
  source = "./modules/logging-sink"

  project_id  = "my-project-id"
  name        = "audit-to-bq"
  destination = "bigquery.googleapis.com/projects/my-project-id/datasets/audit_logs"
  filter      = "logName:cloudaudit.googleapis.com"
}

# Grant the sink's writer identity access to the destination dataset
module "sink_bq_grant" {
  source = "./modules/project-iam"

  project_id = "my-project-id"
  role       = "roles/bigquery.dataEditor"
  members    = [module.audit_sink.writer_identity]
}

# Sink to GCS with an exclusion filter
module "app_sink" {
  source = "./modules/logging-sink"

  project_id  = "my-project-id"
  name        = "app-logs-to-gcs"
  destination = "storage.googleapis.com/my-log-bucket"
  filter      = "resource.type=cloud_run_revision"

  exclusions = [
    {
      name   = "health-checks"
      filter = "httpRequest.requestUrl=\"/healthz\""
    },
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_logging_project_sink.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the log sink. | `string` | n/a | yes |
| <a name="input_destination"></a> [destination](#input\_destination) | The destination URI. Examples: bigquery.googleapis.com/projects/P/datasets/D, storage.googleapis.com/my-bucket. | `string` | n/a | yes |
| <a name="input_filter"></a> [filter](#input\_filter) | Cloud Logging filter expression. Empty string exports all logs. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Optional human-readable description for the sink. | `string` | `null` | no |
| <a name="input_disabled"></a> [disabled](#input\_disabled) | Set to true to disable the sink without deleting it. | `bool` | `false` | no |
| <a name="input_exclusions"></a> [exclusions](#input\_exclusions) | Log exclusion filters applied before routing to the destination. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string)<br/>    filter      = string<br/>    disabled    = optional(bool, false)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_writer_identity"></a> [writer\_identity](#output\_writer\_identity) | The service account that writes to the destination. Grant this identity IAM access on the destination resource. |
| <a name="output_name"></a> [name](#output\_name) | Name of the log sink. |
| <a name="output_id"></a> [id](#output\_id) | Fully-qualified sink resource ID. |
<!-- END_TF_DOCS -->
