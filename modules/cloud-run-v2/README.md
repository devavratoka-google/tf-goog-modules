# Cloud Run Module

Cloud Run Services and Jobs, with support for IAM roles and Eventarc trigger creation. This module uses provider default value for `deletion_protection`, which means service is by default protected from removal (or reprovisioning).

<!-- BEGIN TOC -->
- [IAM and environment variables](#iam-and-environment-variables)
- [Mounting secrets as volumes](#mounting-secrets-as-volumes)
- [Mounting GCS buckets](#mounting-gcs-buckets)
- [Connecting to Cloud SQL database](#connecting-to-cloud-sql-database)
- [Direct VPC Egress](#direct-vpc-egress)
- [VPC Access Connector](#vpc-access-connector)
- [Using Customer-Managed Encryption Key](#using-customer-managed-encryption-key)
- [Deploying OpenTelemetry Collector sidecar](#deploying-opentelemetry-collector-sidecar)
- [Eventarc triggers](#eventarc-triggers)
  - [PubSub](#pubsub)
  - [Audit logs](#audit-logs)
  - [GCS bucket](#gcs-bucket)
- [Cloud Run Invoker IAM Disable](#cloud-run-invoker-iam-disable)
- [Cloud Run Service Account](#cloud-run-service-account)
- [Creating Cloud Run Jobs](#creating-cloud-run-jobs)
- [Tag bindings](#tag-bindings)
- [IAP Configuration](#iap-configuration)
- [Adding GPUs](#adding-gpus)
- [Variables](#variables)
- [Outputs](#outputs)
- [Fixtures](#fixtures)
<!-- END TOC -->

## IAM and environment variables

IAM bindings support the usual syntax. Container environment values can be declared as key-value strings or as references to Secret Manager secrets. Both can be combined as long as there is no duplication of keys:

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "example-hello"
  region     = var.region
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      env = {
        VAR1 = "VALUE1"
        VAR2 = "VALUE2"
      }
      env_from_key = {
        SECRET1 = {
          secret  = module.secret-manager.secrets["credentials"].name
          version = module.secret-manager.version_versions["credentials/v1"]
        }
      }
    }
  }
  iam = {
    "roles/run.invoker" = ["allUsers"]
  }
  deletion_protection = false
}
# tftest fixtures=fixtures/secret-credentials.tf inventory=service-iam-env.yaml e2e skip-tofu
```

## Mounting secrets as volumes

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "example-hello"
  region     = var.region
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      volume_mounts = {
        "credentials" = "/credentials"
      }
    }
  }
  volumes = {
    credentials = {
      secret = {
        name    = module.secret-manager.secrets["credentials"].id
        path    = "my-secret"
        version = "latest" # TODO: should be optional, but results in API error
      }
    }
  }
  deletion_protection = false
}
# tftest fixtures=fixtures/secret-credentials.tf inventory=service-volume-secretes.yaml e2e skip-tofu
```

## Mounting GCS buckets

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "example-hello"
  region     = var.region
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      volume_mounts = {
        bucket = "/bucket"
      }
    }
  }
  service_config = {
    gen2_execution_environment = true
  }
  volumes = {
    bucket = {
      gcs = {
        bucket       = var.bucket
        is_read_only = false
        mount_options = [ # Beta feature
          "metadata-cache-ttl-secs=120s",
          "type-cache-max-size-mb=4",
        ]
      }
    }
  }
  deletion_protection = false
}
# tftest inventory=gcs-mount.yaml e2e
```

## Connecting to Cloud SQL database

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      volume_mounts = {
        cloudsql = "/cloudsql"
      }
    }
  }
  volumes = {
    "cloudsql" = {
      cloud_sql_instances = [module.cloudsql-instance.connection_name]
    }
  }
  deletion_protection = false
}
# tftest fixtures=fixtures/cloudsql-instance.tf inventory=cloudsql.yaml e2e
```

## Direct VPC Egress

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "example-hello"
  region     = var.region
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  revision = {
    vpc_access = {
      egress = "ALL_TRAFFIC"
      subnet = var.subnet.name
      tags   = ["tag1", "tag2", "tag3"]
    }
  }
  service_config = {
    gen2_execution_environment = true
    max_instance_count         = 20
  }
  deletion_protection = false
}
# E2E test disabled due to b/332419038
# tftest inventory=service-direct-vpc.yaml
```

## VPC Access Connector

You can use an existing [VPC Access Connector](https://cloud.google.com/vpc/docs/serverless-vpc-access) to connect to a VPC from Cloud Run.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.regions.secondary
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  service_config = {
    vpc_access = {
      connector = google_vpc_access_connector.connector.id
      egress    = "ALL_TRAFFIC"
    }
  }
  deletion_protection = false
}
# tftest fixtures=fixtures/vpc-connector.tf inventory=service-vpc-access-connector.yaml e2e
```

If creation of the VPC Access Connector is required, use the `vpc_connector_create` variable which also supports optional attributes like number of instances, machine type, or throughput. The connector will be used automatically by Cloud Run Service and Job. Worker Pool does not support connector.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  vpc_connector_create = {
    ip_cidr_range = "10.10.10.0/28"
    network       = var.vpc.self_link
    instances = {
      max = 10
      min = 3
    }
  }
  deletion_protection = false
}
# tftest inventory=service-vpc-access-connector-create.yaml e2e
```

Note that if you are using a Shared VPC for the connector, you need to specify a subnet and the host project if this is not where the Cloud Run service is deployed.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = module.project-service.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  vpc_connector_create = {
    machine_type = "e2-standard-4"
    subnet = {
      name       = module.net-vpc-host.subnets["${var.region}/fixture-subnet-28"].name
      project_id = module.project-host.project_id
    }
    throughput = {
      max = 300
      min = 200
    }
  }
  deletion_protection = false
}
# tftest fixtures=fixtures/shared-vpc.tf inventory=service-vpc-access-connector-create-sharedvpc.yaml e2e
```

## Using Customer-Managed Encryption Key

Deploy a Cloud Run service with environment variables encrypted using a Customer-Managed Encryption Key (CMEK). Ensure you specify the encryption_key with the full resource identifier of your Cloud KMS CryptoKey and that Cloud Run Service agent (`service-<PROJECT_NUMBER>@serverless-robot-prod.iam.gserviceaccount.com`) has permission to use the key, for example `roles/cloudkms.cryptoKeyEncrypterDecrypter` IAM role. This setup adds an extra layer of security by utilizing your own encryption keys.

```hcl
module "project" {
  source          = "./fabric/modules/project"
  name            = "cloudrun"
  billing_account = var.billing_account_id
  prefix          = var.prefix
  parent          = var.folder_id
  services = [
    "cloudkms.googleapis.com",
    "run.googleapis.com",
  ]
}

module "kms" {
  source     = "./fabric/modules/kms"
  project_id = module.project.project_id
  keyring = {
    location = var.region
    name     = "${var.prefix}-keyring"
  }
  keys = {
    "key-regional" = {
    }
  }
  iam = {
    "roles/cloudkms.cryptoKeyEncrypterDecrypter" = [
      module.project.service_agents.run.iam_email
    ]
  }
}

module "cloud_run" {
  source         = "./fabric/modules/cloud-run-v2"
  project_id     = module.project.project_id
  region         = var.region
  name           = "example-hello"
  encryption_key = module.kms.keys.key-regional.id
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  deletion_protection = false
}
# tftest inventory=cmek.yaml e2e
```

## Deploying OpenTelemetry Collector sidecar

```yaml
# Reference: https://cloud.google.com/stackdriver/docs/instrumentation/opentelemetry-collector-cloud-run#gotc-provided-config

receivers:
  # Open two OTLP servers:
  # - On port 4317, open an OTLP GRPC server
  # - On port 4318, open an OTLP HTTP server
  #
  # Docs:
  # https://github.com/open-telemetry/opentelemetry-collector/tree/main/receiver/otlpreceiver
  otlp:
    protocols:
      grpc:
        endpoint: localhost:4317
      http:
        cors:
          # This effectively allows any origin
          # to make requests to the HTTP server.
          allowed_origins:
          - http://*
          - https://*
        endpoint: localhost:4318

  # Using the prometheus scraper, scrape the Collector's self metrics.
  #
  # Docs:
  # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/prometheusreceiver
  # https://opentelemetry.io/docs/collector/internal-telemetry/
  prometheus/self-metrics:
    config:
      scrape_configs:
      - job_name: otel-self-metrics
        scrape_interval: 1m
        static_configs:
        - targets:
          - localhost:8888

processors:
  # The batch processor is in place to regulate both the number of requests
  # being made and the size of those requests.
  #
  # Docs:
  # https://github.com/open-telemetry/opentelemetry-collector/tree/main/processor/batchprocessor
  batch:
    send_batch_max_size: 200
    send_batch_size: 200
    timeout: 5s

  # The memorylimiter will check the memory usage of the collector process.
  #
  # Docs:
  # https://github.com/open-telemetry/opentelemetry-collector/tree/main/processor/memorylimiterprocessor
  memory_limiter:
    check_interval: 1s
    limit_percentage: 65
    spike_limit_percentage: 20

  # The resourcedetection processor is configured to detect GCP resources.
  # Resource attributes that represent the GCP resource the collector is
  # running on will be attached to all telemetry that goes through this
  # processor.
  #
  # Docs:
  # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/resourcedetectionprocessor
  # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/resourcedetectionprocessor#gcp-metadata
  resourcedetection:
    detectors: [gcp]
    timeout: 10s

  # The transform/collision processor ensures that any attributes that may
  # collide with the googlemanagedprometheus exporter's monitored resource
  # construction are moved to a similar name that is not reserved.
  transform/collision:
    metric_statements:
    - context: datapoint
      statements:
      - set(attributes["exported_location"], attributes["location"])
      - delete_key(attributes, "location")
      - set(attributes["exported_cluster"], attributes["cluster"])
      - delete_key(attributes, "cluster")
      - set(attributes["exported_namespace"], attributes["namespace"])
      - delete_key(attributes, "namespace")
      - set(attributes["exported_job"], attributes["job"])
      - delete_key(attributes, "job")
      - set(attributes["exported_instance"], attributes["instance"])
      - delete_key(attributes, "instance")
      - set(attributes["exported_project_id"], attributes["project_id"])
      - delete_key(attributes, "project_id")

exporters:
  # The googlecloud exporter will export telemetry to different
  # Google Cloud services:
  # Logs -> Cloud Logging
  # Metrics -> Cloud Monitoring
  # Traces -> Cloud Trace
  #
  # Docs:
  # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/googlecloudexporter
  googlecloud:
    log:
      default_log_name: opentelemetry-collector

  # The googlemanagedprometheus exporter will send metrics to
  # Google Managed Service for Prometheus.
  #
  # Docs:
  # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/googlemanagedprometheusexporter
  googlemanagedprometheus:

extensions:
  # Opens an endpoint on 13133 that can be used to check the
  # status of the collector. Since this does not configure the
  # `path` config value, the endpoint will default to `/`.
  #
  # When running on Cloud Run, this extension is required and not optional.
  # In other environments it is recommended but may not be required for operation
  # (i.e. in Container-Optimized OS or other GCE environments).
  #
  # Docs:
  # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/extension/healthcheckextension
  health_check:
    endpoint: 0.0.0.0:13133

service:
  extensions:
  - health_check
  pipelines:
    logs:
      receivers:
      - otlp
      processors:
      - resourcedetection
      - memory_limiter
      - batch
      exporters:
      - googlecloud
    metrics/otlp:
      receivers:
      - otlp
      processors:
      - transform/collision
      - resourcedetection
      - memory_limiter
      - batch
      exporters:
      - googlemanagedprometheus
    metrics/self-metrics:
      receivers:
      - prometheus/self-metrics
      processors:
      - resourcedetection
      - memory_limiter
      - batch
      exporters:
      - googlemanagedprometheus
    traces:
      receivers:
      - otlp
      processors:
      - resourcedetection
      - memory_limiter
      - batch
      exporters:
      - googlecloud
  telemetry:
    metrics:
      address: localhost:8888

# tftest-file id=otel-config path=config/otel-config.yaml
```

```hcl
module "secrets" {
  source     = "./fabric/modules/secret-manager"
  project_id = var.project_id
  secrets = {
    otel-config = {
      iam = {
        "roles/secretmanager.secretAccessor" = [module.cloud_run.service_account_iam_email]
      }
      versions = {
        v1 = {
          data = file("${path.module}/config/otel-config.yaml")
        }
      }
    }
  }
}
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      ports = {
        default = {
          container_port = 3000
        }
      }
      depends_on = ["collector"]
    }
    collector = {
      image = "us-docker.pkg.dev/cloud-ops-agents-artifacts/google-cloud-opentelemetry-collector/otelcol-google:0.122.1"
      startup_probe = {
        http_get = {
          path = "/"
          port = 13133
        }
        timeout_seconds = 30
        period_seconds  = 30
      }
      liveness_probe = {
        http_get = {
          path = "/"
          port = 13133
        }
        timeout_seconds = 30
        period_seconds  = 30
      }
      volume_mounts = {
        "otel-config" = "/etc/otelcol-google/"
      }
    }
  }
  volumes = {
    otel-config = {
      secret = {
        name    = "otel-config"
        version = "1"
        path    = "config.yaml"
      }
    }
  }
  deletion_protection = false
}
# tftest files=otel-config inventory=service-otel-sidecar.yaml e2e skip-tofu
```

## Eventarc triggers

### PubSub

This deploys a Cloud Run service that will be triggered when messages are published to Pub/Sub topics.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  service_config = {
    eventarc_triggers = {
      pubsub = {
        topic-1 = module.pubsub.topic.name
      }
    }
  }
  deletion_protection = false
}
# tftest fixtures=fixtures/pubsub.tf inventory=service-eventarc-pubsub.yaml e2e
```

### Audit logs

This deploys a Cloud Run service that will be triggered when specific log events are written to Google Cloud audit logs.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  service_config = {
    eventarc_triggers = {
      audit_log = {
        setiampolicy = {
          method  = "SetIamPolicy"
          service = "cloudresourcemanager.googleapis.com"
        }
      }
      service_account_email = module.iam-service-account.email
    }
  }
  iam = {
    "roles/run.invoker" = [module.iam-service-account.iam_email]
  }
  deletion_protection = false
  depends_on          = [google_project_iam_member.eventarc_receiver]
}

resource "google_project_iam_member" "eventarc_receiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = module.iam-service-account.iam_email
}
# tftest fixtures=fixtures/iam-service-account.tf inventory=service-eventarc-auditlogs-external-sa.yaml e2e
```

### GCS bucket

This deploys a Cloud Run service that will be triggered when files are uploaded to a GCS bucket.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  service_config = {
    eventarc_triggers = {
      storage = {
        bucket-upload = {
          bucket = module.gcs.name
          path   = "/webhook" # optional: URL path for the Cloud Run service
        }
      }
      service_account_email = module.iam-service-account.email
    }
  }
  deletion_protection = false
  depends_on = [
    google_project_iam_member.gcs_pubsb_publisher,
    google_project_iam_member.trigger_sa_event_receiver,
  ]
}

resource "google_project_iam_member" "trigger_sa_event_receiver" {
  member  = module.iam-service-account.iam_email
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
}

resource "google_project_iam_member" "gcs_pubsb_publisher" {
  member  = "serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"
  project = var.project_id
  role    = "roles/pubsub.publisher"
}

# tftest fixtures=fixtures/gcs.tf,fixtures/iam-service-account.tf inventory=service-eventarc-storage.yaml e2e
```

## Cloud Run Invoker IAM Disable

To disables IAM permission check for `run.routes.invoke` for callers of this service set the `invoker_iam_disabled` variable of the module to `true` (default `false`). There should be no requirement to pass the `roles/run.invoker` to the IAM block to enable public access. This allows for the org policy `domain restricted sharing` org policy remain enabled.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  service_config = {
    invoker_iam_disabled = true
  }
  deletion_protection = false
}
# tftest inventory=service-invoker-iam-disable.yaml e2e
```

## Cloud Run Service Account

The module by default creates a service account that is associated with the Cloud Run instance. It grants the service account `roles/logging.logWriter` and `roles/monitoring.metricWriter` roles.

To assign non-default roles, pass them as `service_account_config.roles`.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  service_account_config = {
    roles = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
      "roles/cloudsql.client",
      "roles/cloudsql.instanceUser",
    ]
  }
  deletion_protection = false
}
# tftest inventory=service-sa-create.yaml e2e
```

To use externally managed service account, pass its email in `service_account_config.email` and set `service_account_config.email` to `false`.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  region     = var.region
  name       = "example-hello"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  service_account_config = {
    create = false
    email  = module.iam-service-account.email
  }
  deletion_protection = false
}
# tftest fixtures=fixtures/iam-service-account.tf inventory=service-external-sa.yaml e2e
```

## Creating Cloud Run Jobs

To create a job instead of service set `type` to `JOB`. Jobs support all functions above apart from triggers.

Unsupported variables / attributes:

- ingress
- revision.gen2_execution_environment (they run by default in gen2)
- revision.name
- containers.liveness_probe
- containers.startup_probe
- containers.resources.cpu_idle
- containers.resources.startup_cpu_boost

Additional configuration can be passwed as `job_config`:

- max_retries - maximum of retries per task
- task_count - desired number of tasks
- timeout - max allowed time per task, in seconds with up to nine fractional digits, ending with 's'. Example: `3.5s`

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "example-hello"
  region     = var.region
  type       = "JOB"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      env = {
        VAR1 = "VALUE1"
        VAR2 = "VALUE2"
      }
    }
  }
  iam = {
    "roles/run.invoker" = ["group:${var.group_email}"]
  }
  deletion_protection = false
}

# tftest inventory=job-iam-env.yaml e2e
```

## Tag bindings

Tag bindings are not yet supported for Worker Pool. Refer to the [Creating and managing tags](https://cloud.google.com/resource-manager/docs/tags/tags-creating-and-managing) documentation for details on usage.

```hcl
module "project" {
  source = "./fabric/modules/project"
  name   = var.project_id
  project_reuse = {
    use_data_source = false
    attributes = {
      name   = var.project_id
      number = var.project_number
    }
  }
  tags = {
    run_environment = {
      description = "Environment specification."
      values = {
        dev     = {}
        prod    = {}
        sandbox = {}
      }
    }
  }
}

module "cloud_run_service" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "hello-service"
  region     = var.region
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  tag_bindings = {
    env-sandbox = module.project.tag_values["run_environment/sandbox"].id
  }
  deletion_protection = false
}

module "cloud_run_job" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "hello-job"
  region     = var.region
  type       = "JOB"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  tag_bindings = {
    env-sandbox = module.project.tag_values["run_environment/sandbox"].id
  }
  deletion_protection = false
}

# tftest inventory=tags.yaml e2e
```

## IAP Configuration

IAP is only supported for service. Refer to the [Configure IAP directly on cloud run](https://cloud.google.com/run/docs/securing/identity-aware-proxy-cloud-run) documentation for details on usage.

```hcl
module "cloud_run" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "example-hello"
  region     = var.region
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  service_config = {
    iap_config = {
      iam = ["group:${var.group_email}"]
    }
  }
  deletion_protection = false
}
# tftest inventory=iap.yaml e2e
```

## Adding GPUs

GPU support is available for all types of Cloud Run resources: jobs, services and worker pools.

```hcl
module "job" {
  source       = "./fabric/modules/cloud-run-v2"
  project_id   = var.project_id
  name         = "example-job"
  region       = var.region
  launch_stage = "BETA"
  revision = {
    gpu_zonal_redundancy_disabled = true
    node_selector = {
      accelerator = "nvidia-l4"
    }
  }
  type = "JOB"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      resources = {
        limits = {
          cpu              = "4000m"
          memory           = "16Gi"
          "nvidia.com/gpu" = "1"
        }
      }
    }
  }
  deletion_protection = false
}
# tftest inventory=gpu-job.yaml
```

```hcl
module "service" {
  source     = "./fabric/modules/cloud-run-v2"
  project_id = var.project_id
  name       = "service"
  region     = var.region
  revision = {
    gpu_zonal_redundancy_disabled = true
    node_selector = {
      accelerator = "nvidia-l4"
    }
  }
  service_config = {
    gen2_execution_environment = true
  }
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      resources = {
        limits = {
          cpu              = "4000m"
          memory           = "16Gi"
          "nvidia.com/gpu" = "1"
        }
      }
    }
  }
  deletion_protection = false
}
# tftest inventory=gpu-service.yaml e2e
```

```hcl
module "worker" {
  source       = "./fabric/modules/cloud-run-v2"
  project_id   = var.project_id
  name         = "worker"
  region       = var.region
  launch_stage = "BETA"
  revision = {
    gpu_zonal_redundancy_disabled = true
    node_selector = {
      accelerator = "nvidia-l4"
    }
  }
  type = "WORKERPOOL"
  containers = {
    hello = {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      resources = {
        limits = {
          cpu              = "4000m"
          memory           = "16Gi"
          "nvidia.com/gpu" = "1"
        }
      }
    }
  }
  deletion_protection = false
}
# tftest inventory=gpu-workerpool.yaml e2e
```
<!-- BEGIN TFDOC -->
## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [name](variables.tf#L178) | Name used for Cloud Run service. | <code>string</code> | ✓ |  |
| [project_id](variables.tf#L183) | Project id used for all resources. | <code>string</code> | ✓ |  |
| [region](variables.tf#L188) | Region used for all resources. | <code>string</code> | ✓ |  |
| [containers](variables.tf#L17) | Containers in name => attributes format. | <code>map&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [context](variables.tf#L97) | Context-specific interpolations. | <code>object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>&#123;&#125;</code> |
| [deletion_protection](variables.tf#L115) | Deletion protection setting for this Cloud Run service. | <code>string</code> |  | <code>null</code> |
| [encryption_key](variables.tf#L121) | The full resource name of the Cloud KMS CryptoKey. | <code>string</code> |  | <code>null</code> |
| [iam](variables.tf#L127) | IAM bindings for Cloud Run service in {ROLE => [MEMBERS]} format. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [job_config](variables.tf#L133) | Cloud Run Job specific configuration. | <code>object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>&#123;&#125;</code> |
| [labels](variables.tf#L148) | Resource labels. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [launch_stage](variables.tf#L154) | The launch stage as defined by Google Cloud Platform Launch Stages. | <code>string</code> |  | <code>null</code> |
| [managed_revision](variables.tf#L171) | Whether the Terraform module should control the deployment of revisions. | <code>bool</code> |  | <code>true</code> |
| [revision](variables.tf#L193) | Revision template configurations. | <code>object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>&#123;&#125;</code> |
| [service_account_config](variables-serviceaccount.tf#L17) | Service account configurations. | <code>object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>&#123;&#125;</code> |
| [service_config](variables.tf#L260) | Cloud Run service specific configuration options. | <code>object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>&#123;&#125;</code> |
| [tag_bindings](variables.tf#L323) | Tag bindings for this service, in key => tag value id format. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [type](variables.tf#L330) | Type of Cloud Run resource to deploy: JOB, SERVICE or WORKERPOOL. | <code>string</code> |  | <code>&#34;SERVICE&#34;</code> |
| [volumes](variables.tf#L340) | Named volumes in containers in name => attributes format. | <code>map&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [vpc_connector_create](variables-vpcconnector.tf#L17) | VPC connector network configuration. Must be provided if new VPC connector is being created. | <code>object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>null</code> |
| [workerpool_config](variables.tf#L374) | Cloud Run Worker Pool specific configuration. | <code>object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>&#123;&#125;</code> |

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
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.28.0, < 8.0.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 7.28.0, < 8.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.28.0, < 8.0.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 7.28.0, < 8.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_cloud_run_v2_job.job](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_job) | resource |
| [google-beta_google_cloud_run_v2_job.job_unmanaged](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_job) | resource |
| [google-beta_google_cloud_run_v2_service.service](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_service) | resource |
| [google-beta_google_cloud_run_v2_service.service_unmanaged](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_service) | resource |
| [google-beta_google_cloud_run_v2_worker_pool.default_managed](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_worker_pool) | resource |
| [google-beta_google_cloud_run_v2_worker_pool.default_unmanaged](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_worker_pool) | resource |
| [google_cloud_run_v2_job_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job_iam_binding) | resource |
| [google_cloud_run_v2_service_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam_binding) | resource |
| [google_cloud_run_v2_worker_pool_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_worker_pool_iam_binding) | resource |
| [google_eventarc_trigger.audit_log_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/eventarc_trigger) | resource |
| [google_eventarc_trigger.pubsub_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/eventarc_trigger) | resource |
| [google_eventarc_trigger.storage_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/eventarc_trigger) | resource |
| [google_iap_web_cloud_run_service_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_cloud_run_service_iam_binding) | resource |
| [google_iap_web_cloud_run_service_iam_member.member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_cloud_run_service_iam_member) | resource |
| [google_project_iam_member.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_tags_location_tag_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_location_tag_binding) | resource |
| [google_vpc_access_connector.connector](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vpc_access_connector) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_containers"></a> [containers](#input\_containers) | Containers in name => attributes format. | <pre>map(object({<br/>    image      = string<br/>    depends_on = optional(list(string))<br/>    command    = optional(list(string))<br/>    args       = optional(list(string))<br/>    env        = optional(map(string))<br/>    env_from_key = optional(map(object({<br/>      secret  = string<br/>      version = string<br/>    })))<br/>    liveness_probe = optional(object({<br/>      grpc = optional(object({<br/>        port    = optional(number)<br/>        service = optional(string)<br/>      }))<br/>      http_get = optional(object({<br/>        http_headers = optional(map(string))<br/>        path         = optional(string)<br/>        port         = optional(number)<br/>      }))<br/>      failure_threshold     = optional(number)<br/>      initial_delay_seconds = optional(number)<br/>      period_seconds        = optional(number)<br/>      timeout_seconds       = optional(number)<br/>    }))<br/>    ports = optional(map(object({<br/>      container_port = optional(number)<br/>      name           = optional(string)<br/>    })))<br/>    resources = optional(object({<br/>      limits            = optional(map(string))<br/>      cpu_idle          = optional(bool)<br/>      startup_cpu_boost = optional(bool)<br/>    }))<br/>    startup_probe = optional(object({<br/>      grpc = optional(object({<br/>        port    = optional(number)<br/>        service = optional(string)<br/>      }))<br/>      http_get = optional(object({<br/>        http_headers = optional(map(string))<br/>        path         = optional(string)<br/>        port         = optional(number)<br/>      }))<br/>      tcp_socket = optional(object({<br/>        port = optional(number)<br/>      }))<br/>      failure_threshold     = optional(number)<br/>      initial_delay_seconds = optional(number)<br/>      period_seconds        = optional(number)<br/>      timeout_seconds       = optional(number)<br/>    }))<br/>    volume_mounts = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_context"></a> [context](#input\_context) | Context-specific interpolations. | <pre>object({<br/>    condition_vars = optional(map(map(string)), {}) # not needed here?<br/>    cidr_ranges    = optional(map(string), {})<br/>    custom_roles   = optional(map(string), {})<br/>    iam_principals = optional(map(string), {})<br/>    kms_keys       = optional(map(string), {})<br/>    locations      = optional(map(string), {})<br/>    networks       = optional(map(string), {})<br/>    project_ids    = optional(map(string), {})<br/>    subnets        = optional(map(string), {})<br/>    tag_values     = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Deletion protection setting for this Cloud Run service. | `string` | `null` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | The full resource name of the Cloud KMS CryptoKey. | `string` | `null` | no |
| <a name="input_iam"></a> [iam](#input\_iam) | IAM bindings for Cloud Run service in {ROLE => [MEMBERS]} format. | `map(list(string))` | `{}` | no |
| <a name="input_job_config"></a> [job\_config](#input\_job\_config) | Cloud Run Job specific configuration. | <pre>object({<br/>    max_retries = optional(number)<br/>    task_count  = optional(number)<br/>    timeout     = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Resource labels. | `map(string)` | `{}` | no |
| <a name="input_launch_stage"></a> [launch\_stage](#input\_launch\_stage) | The launch stage as defined by Google Cloud Platform Launch Stages. | `string` | `null` | no |
| <a name="input_managed_revision"></a> [managed\_revision](#input\_managed\_revision) | Whether the Terraform module should control the deployment of revisions. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name used for Cloud Run service. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id used for all resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region used for all resources. | `string` | n/a | yes |
| <a name="input_revision"></a> [revision](#input\_revision) | Revision template configurations. | <pre>object({<br/>    gpu_zonal_redundancy_disabled = optional(bool)<br/>    labels                        = optional(map(string))<br/>    name                          = optional(string)<br/>    node_selector = optional(object({<br/>      accelerator = string<br/>    }))<br/>    vpc_access = optional(object({<br/>      connector = optional(string)<br/>      egress    = optional(string)<br/>      network   = optional(string)<br/>      subnet    = optional(string)<br/>      tags      = optional(list(string))<br/>    }), {})<br/>    timeout = optional(string)<br/>    # deprecated fields<br/>    gen2_execution_environment = optional(any) # DEPRECATED<br/>    job                        = optional(any) # DEPRECATED<br/>    max_concurrency            = optional(any) # DEPRECATED<br/>    max_instance_count         = optional(any) # DEPRECATED<br/>    min_instance_count         = optional(any) # DEPRECATED<br/>  })</pre> | `{}` | no |
| <a name="input_service_account_config"></a> [service\_account\_config](#input\_service\_account\_config) | Service account configurations. | <pre>object({<br/>    create       = optional(bool, true)<br/>    display_name = optional(string)<br/>    email        = optional(string)<br/>    name         = optional(string)<br/>    roles = optional(list(string), [<br/>      "roles/logging.logWriter",<br/>      "roles/monitoring.metricWriter"<br/>    ])<br/>  })</pre> | `{}` | no |
| <a name="input_service_config"></a> [service\_config](#input\_service\_config) | Cloud Run service specific configuration options. | <pre>object({<br/>    custom_audiences = optional(list(string), null)<br/>    eventarc_triggers = optional(<br/>      object({<br/>        audit_log = optional(map(object({<br/>          method  = string<br/>          service = string<br/>        })))<br/>        pubsub = optional(map(string))<br/>        storage = optional(map(object({<br/>          bucket = string<br/>          path   = optional(string)<br/>        })))<br/>        service_account_email = optional(string)<br/>    }), {})<br/>    gen2_execution_environment = optional(bool, false)<br/>    iap_config = optional(object({<br/>      iam          = optional(list(string), [])<br/>      iam_additive = optional(list(string), [])<br/>    }), null)<br/>    ingress              = optional(string, null)<br/>    invoker_iam_disabled = optional(bool, false)<br/>    max_concurrency      = optional(number)<br/>    scaling = optional(object({<br/>      max_instance_count = optional(number)<br/>      min_instance_count = optional(number)<br/>    }))<br/>    timeout = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_tag_bindings"></a> [tag\_bindings](#input\_tag\_bindings) | Tag bindings for this service, in key => tag value id format. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of Cloud Run resource to deploy: JOB, SERVICE or WORKERPOOL. | `string` | `"SERVICE"` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Named volumes in containers in name => attributes format. | <pre>map(object({<br/>    secret = optional(object({<br/>      name         = string<br/>      default_mode = optional(string)<br/>      path         = optional(string)<br/>      version      = optional(string)<br/>      mode         = optional(string)<br/>    }))<br/>    cloud_sql_instances = optional(list(string))<br/>    empty_dir_size      = optional(string)<br/>    gcs = optional(object({<br/>      # needs revision.gen2_execution_environment<br/>      bucket       = string<br/>      is_read_only = optional(bool)<br/>    }))<br/>    nfs = optional(object({<br/>      server       = string<br/>      path         = optional(string)<br/>      is_read_only = optional(bool)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_connector_create"></a> [vpc\_connector\_create](#input\_vpc\_connector\_create) | VPC connector network configuration. Must be provided if new VPC connector is being created. | <pre>object({<br/>    ip_cidr_range = optional(string)<br/>    machine_type  = optional(string)<br/>    name          = optional(string)<br/>    network       = optional(string)<br/>    instances = optional(object({<br/>      max = optional(number)<br/>      min = optional(number)<br/>      }), {}<br/>    )<br/>    throughput = optional(object({<br/>      max = optional(number)<br/>      min = optional(number)<br/>      }), {}<br/>    )<br/>    subnet = optional(object({<br/>      name       = optional(string)<br/>      project_id = optional(string)<br/>    }), {})<br/>  })</pre> | `null` | no |
| <a name="input_workerpool_config"></a> [workerpool\_config](#input\_workerpool\_config) | Cloud Run Worker Pool specific configuration. | <pre>object({<br/>    scaling = optional(object({<br/>      manual_instance_count = optional(number)<br/>      max_instance_count    = optional(number)<br/>      min_instance_count    = optional(number)<br/>      mode                  = optional(string)<br/>    }))<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Fully qualified job or service id. |
| <a name="output_invoke_command"></a> [invoke\_command](#output\_invoke\_command) | Command to invoke Cloud Run Service / submit job. |
| <a name="output_job"></a> [job](#output\_job) | Cloud Run Job. |
| <a name="output_resource"></a> [resource](#output\_resource) | Cloud Run resource (job, service or worker\_pool). |
| <a name="output_resource_name"></a> [resource\_name](#output\_resource\_name) | Cloud Run resource (job, service or workerpool)  service name. |
| <a name="output_service"></a> [service](#output\_service) | Cloud Run Service. |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account resource. |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Service account email. |
| <a name="output_service_account_iam_email"></a> [service\_account\_iam\_email](#output\_service\_account\_iam\_email) | Service account email. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Cloud Run service name. |
| <a name="output_service_uri"></a> [service\_uri](#output\_service\_uri) | Main URI in which the service is serving traffic. |
| <a name="output_vpc_connector"></a> [vpc\_connector](#output\_vpc\_connector) | VPC connector resource if created. |
<!-- END_TF_DOCS -->
