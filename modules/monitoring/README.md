# Monitoring

Manages Cloud Monitoring resources for a GCP project:

- **Notification channels** — email, PagerDuty, Slack, etc.
- **Uptime checks** — HTTP/HTTPS endpoint availability checks
- **Alert policies** — threshold-based and MQL conditions with optional
  auto-close and documentation

All three resource types are optional. Pass only the maps relevant to your
use case; empty maps create no resources.

## Usage

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  project_id = "my-project-id"

  notification_channels = {
    "ops-email" = {
      type   = "email"
      labels = { email_address = "ops@example.com" }
    }
  }

  uptime_checks = {
    "portal-health" = {
      display_name = "Portal HTTPS uptime"
      timeout      = "10s"
      period       = "60s"
      http_check = {
        path         = "/healthz"
        port         = 443
        use_ssl      = true
        validate_ssl = true
      }
      monitored_resource = {
        type   = "uptime_url"
        labels = { host = "portal.example.com", project_id = "my-project-id" }
      }
    }
  }

  alert_policies = {
    "high-error-rate" = {
      combiner = "OR"
      notification_channels = [
        module.monitoring.notification_channel_ids["ops-email"]
      ]
      conditions = [
        {
          display_name = "Error rate > 5%"
          condition_threshold = {
            filter          = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" metric.label.response_code_class!=\"2xx\""
            comparison      = "COMPARISON_GT"
            duration        = "60s"
            threshold_value = 0.05
            aggregations = [
              { alignment_period = "60s", per_series_aligner = "ALIGN_RATE" }
            ]
          }
        }
      ]
      documentation  = "Error rate exceeded 5% over the last 60 seconds."
      alert_strategy = { auto_close = "1800s" }
    }
  }
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
| [google_monitoring_notification_channel.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_monitoring_uptime_check_config.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_uptime_check_config) | resource |
| [google_monitoring_alert_policy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID. | `string` | n/a | yes |
| <a name="input_notification_channels"></a> [notification\_channels](#input\_notification\_channels) | Map of channel display\_name => channel config object (`type` and `labels`). | <pre>map(object({<br/>    type   = string<br/>    labels = map(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_uptime_checks"></a> [uptime\_checks](#input\_uptime\_checks) | Map of display\_name => uptime check config. | <pre>map(object({<br/>    display_name = string<br/>    timeout      = string<br/>    period       = optional(string, "300s")<br/>    http_check   = optional(object({<br/>      path         = optional(string, "/")<br/>      port         = optional(number, 443)<br/>      use_ssl      = optional(bool, true)<br/>      validate_ssl = optional(bool, true)<br/>    }))<br/>    monitored_resource = object({<br/>      type   = string<br/>      labels = map(string)<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_alert_policies"></a> [alert\_policies](#input\_alert\_policies) | Map of display\_name => alert policy config. Uses `any` type to accommodate varied condition schemas. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_notification_channel_ids"></a> [notification\_channel\_ids](#output\_notification\_channel\_ids) | Map of channel display\_name => fully-qualified channel name (use as a notification\_channels reference in alert policies). |
| <a name="output_alert_policy_names"></a> [alert\_policy\_names](#output\_alert\_policy\_names) | Map of alert policy display\_name => fully-qualified policy name. |
| <a name="output_uptime_check_ids"></a> [uptime\_check\_ids](#output\_uptime\_check\_ids) | Map of uptime check display\_name => uptime check ID. |
<!-- END_TF_DOCS -->
