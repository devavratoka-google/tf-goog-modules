# Pub/Sub Module

This module deploys a Google Cloud Pub/Sub topic, manages multiple subscriptions (pull, push with OIDC authentication, or BigQuery storage-write subscriptions), and configures additive IAM member bindings for both the topic and its subscriptions.

## Usage

### 1. Push Subscription with OIDC Authentication

```hcl
module "events" {
  source  = "./modules/pubsub"
  project_id = "my-project-id"
  topic_name = "agent-events-dev"

  subscriptions = {
    "events-push" = {
      push_config = {
        push_endpoint = "https://orchestrator.run.app/internal/events"
        oidc_token = {
          service_account_email = "pubsub-invoker@my-project-id.iam.gserviceaccount.com"
          audience              = "https://orchestrator.run.app"
        }
      }
    }
  }
}
```

### 2. BigQuery Storage-Write Firehose Subscription

```hcl
module "events" {
  source     = "./modules/pubsub"
  project_id = "my-project-id"
  topic_name = "agent-events-dev"

  subscriptions = {
    "events-bq-firehose" = {
      bigquery_config = {
        table          = "projects/my-project-id/datasets/analytics/tables/events"
        write_metadata = true
      }
      iam = {
        "roles/pubsub.subscriber" = ["serviceAccount:runtime-sa@my-project-id.iam.gserviceaccount.com"]
      }
    }
  }
}
```

### 3. Topic IAM (Grant Publisher Role)

```hcl
module "events" {
  source     = "./modules/pubsub"
  project_id = "my-project-id"
  topic_name = "agent-events-dev"

  topic_iam = {
    "roles/pubsub.publisher" = ["serviceAccount:publisher-sa@my-project-id.iam.gserviceaccount.com"]
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| google | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The ID of the project in which the Pub/Sub resources will be created. | `string` | n/a | yes |
| topic_name | The name of the Pub/Sub topic. | `string` | n/a | yes |
| labels | A map of labels to apply to the Pub/Sub topic. | `map(string)` | `{}` | no |
| message_retention_duration | How long a topic retains messages (between 3600s and 604800s). | `string` | `null` | no |
| topic_iam | Additive topic-level IAM bindings. | `map(list(string))` | `{}` | no |
| subscriptions | Map of subscription configurations. | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| topic_id | The ID of the created Pub/Sub topic. |
| topic_name | The name of the created Pub/Sub topic. |
| subscription_ids | A map of subscription keys to resource IDs. |
<!-- END_TF_DOCS -->
