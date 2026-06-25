# Cloud Scheduler

Creates a Cloud Scheduler job (`google_cloud_scheduler_job`) with either a
Pub/Sub target or an HTTP target. HTTP targets support OIDC authentication for
invoking authenticated Cloud Run services or other IAP-protected endpoints.

Exactly one of `pubsub_target` or `http_target` must be set.

## Usage

```hcl
# Pub/Sub target — publish a message on a schedule
module "nightly_export" {
  source = "./modules/cloud-scheduler"

  project_id = "my-project-id"
  region     = "us-east4"
  name       = "nightly-export-trigger"
  schedule   = "0 2 * * *"
  time_zone  = "America/New_York"

  pubsub_target = {
    topic_name = "projects/my-project-id/topics/export-trigger"
    data       = "{\"env\":\"prod\"}"
  }
}

# HTTP target — call an authenticated Cloud Run service
module "daily_report" {
  source = "./modules/cloud-scheduler"

  project_id = "my-project-id"
  region     = "us-east4"
  name       = "daily-report-job"
  schedule   = "0 8 * * 1-5"

  http_target = {
    uri         = "https://report-service-abc123-ue.a.run.app/run"
    http_method = "POST"
    body        = "{\"report\":\"daily\"}"
    oidc_token = {
      service_account_email = "scheduler-sa@my-project-id.iam.gserviceaccount.com"
    }
  }
}
```

The `body` field is automatically base64-encoded by the module before passing
it to the provider, so supply it as a plain string.

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
| [google_cloud_scheduler_job.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for the scheduler job. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the scheduler job. | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Cron schedule expression (e.g. '0 0 * * *'). | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Optional description for the job. | `string` | `null` | no |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | IANA time zone for the schedule (e.g. 'America/New\_York'). | `string` | `"UTC"` | no |
| <a name="input_attempt_deadline"></a> [attempt\_deadline](#input\_attempt\_deadline) | Maximum time the scheduler waits for a job attempt to complete. | `string` | `"180s"` | no |
| <a name="input_paused"></a> [paused](#input\_paused) | Set to true to create the job in a paused state. | `bool` | `false` | no |
| <a name="input_pubsub_target"></a> [pubsub\_target](#input\_pubsub\_target) | Pub/Sub target. Set when the job publishes to a topic. Mutually exclusive with http\_target. | <pre>object({<br/>    topic_name = string<br/>    data       = optional(string)<br/>    attributes = optional(map(string), {})<br/>  })</pre> | `null` | no |
| <a name="input_http_target"></a> [http\_target](#input\_http\_target) | HTTP target. Set when the job calls an HTTP endpoint. Mutually exclusive with pubsub\_target. | <pre>object({<br/>    uri         = string<br/>    http_method = optional(string, "POST")<br/>    body        = optional(string)<br/>    headers     = optional(map(string), {})<br/>    oidc_token  = optional(object({<br/>      service_account_email = string<br/>      audience              = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of the scheduler job. |
| <a name="output_id"></a> [id](#output\_id) | Fully-qualified scheduler job resource ID. |
<!-- END_TF_DOCS -->
