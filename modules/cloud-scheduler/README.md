# Cloud Scheduler Module

This module creates a [Cloud Scheduler](https://cloud.google.com/scheduler/docs) job. It supports all three target types: HTTP/HTTPS endpoints, Pub/Sub topics, and App Engine HTTP targets.

## Usage

### HTTP Target with OIDC authentication

```hcl
module "scheduler_job" {
  source = "./modules/cloud-scheduler"

  project_id = "my-project"
  region     = "us-central1"
  name       = "trigger-cloud-run"
  schedule   = "0 9 * * 1"
  time_zone  = "America/Sao_Paulo"

  http_target = {
    uri         = "https://my-service-abc123-uc.a.run.app/trigger"
    http_method = "POST"
    body        = base64encode("{\"action\":\"start\"}")
    headers     = { "Content-Type" = "application/json" }
    oidc_token = {
      service_account_email = "scheduler-sa@my-project.iam.gserviceaccount.com"
    }
  }
}
```

### Pub/Sub Target

```hcl
module "scheduler_job" {
  source = "./modules/cloud-scheduler"

  project_id = "my-project"
  region     = "us-central1"
  name       = "publish-daily-report"
  schedule   = "0 8 * * *"

  pubsub_target = {
    topic_name = "projects/my-project/topics/daily-reports"
    data       = base64encode("{\"report\":\"daily\"}")
    attributes = { "version" = "v1" }
  }

  retry_config = {
    retry_count = 3
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
