# Vertex AI Reasoning Engine

Deploys a [Vertex AI Agent Engine](https://cloud.google.com/vertex-ai/generative-ai/docs/reasoning-engine/overview)
(formerly Reasoning Engine) resource — an ADK-compatible sandbox for hosting
Python-based AI agents on Vertex AI.

The agent package must be staged in GCS before `terraform apply`. The
`spec.package_spec.pickle_object_gcs_uri` points to the serialised agent
object and `spec.package_spec.requirements_gcs_uri` to a `requirements.txt`
for its dependencies.

Uses the `google-beta` provider (`google_vertex_ai_reasoning_engine` is a
beta resource).

## Usage

```hcl
module "agent_engine" {
  source = "./modules/vertex-ai-reasoning-engine"

  project_id   = "my-project-id"
  region       = "us-central1"
  display_name = "my-ai-agent"
  description  = "Production ADK agent"

  spec = {
    package_spec = {
      python_version        = "3.11"
      pickle_object_gcs_uri = "gs://my-bucket/agents/my_agent.pkl"
      requirements_gcs_uri  = "gs://my-bucket/agents/requirements.txt"
    }
    class_methods = [
      { name = "query" },
      { name = "stream_query" },
    ]
  }
}
```

## Notes

- Supported regions are a subset of Vertex AI regions; check the
  [Reasoning Engine locations](https://cloud.google.com/vertex-ai/generative-ai/docs/reasoning-engine/overview#supported-regions)
  documentation before choosing a region.
- The resource has no built-in IAM support — grant callers
  `roles/aiplatform.user` at the project level via the
  [`project-iam`](../project-iam) module.
- `display_name` and `description` are mutable. Changes to `spec` replace the
  resource.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_vertex_ai_reasoning_engine.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/vertex_ai_reasoning_engine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the reasoning engine resource. | `string` | n/a | yes |
| <a name="input_spec"></a> [spec](#input\_spec) | Reasoning Engine spec. `package_spec.python_version` is required. `pickle_object_gcs_uri` points to the serialised agent object in GCS. | <pre>object({<br/>    package_spec = object({<br/>      python_version           = string<br/>      pickle_object_gcs_uri    = optional(string)<br/>      dependency_files_gcs_uri = optional(list(string), [])<br/>      requirements_gcs_uri     = optional(string)<br/>    })<br/>    class_methods = optional(list(object({<br/>      name = string<br/>    })), [])<br/>  })</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Vertex AI region for the reasoning engine. | `string` | `"us-central1"` | no |
| <a name="input_description"></a> [description](#input\_description) | Optional description for the reasoning engine resource. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Fully-qualified reasoning engine resource name. |
| <a name="output_id"></a> [id](#output\_id) | Terraform resource ID of the reasoning engine. |
<!-- END_TF_DOCS -->
