# Vertex AI Reasoning Engine Module

This module creates a Vertex AI Reasoning Engine (Agent Engine) instance.

## Usage

```hcl
module "reasoning_engine" {
  source       = "./modules/vertex-ai-reasoning-engine"
  project_id   = "my-project-id"
  region       = "us-central1"
  display_name = "my-reasoning-engine"
  
  spec = {
    package_spec = {
      python_version        = "3.10"
      pickle_object_gcs_uri = "gs://my-bucket/agent.pkl"
    }
  }
}
```

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
| [google-beta_google_vertex_ai_reasoning_engine.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_vertex_ai_reasoning_engine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | n/a | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_spec"></a> [spec](#input\_spec) | Reasoning Engine spec. package\_spec.python\_version and package\_spec.pickle\_object\_gcs\_uri are required. | <pre>object({<br/>    package_spec = object({<br/>      python_version            = string<br/>      pickle_object_gcs_uri     = optional(string)<br/>      dependency_files_gcs_uri  = optional(list(string), [])<br/>      requirements_gcs_uri      = optional(string)<br/>    })<br/>    class_methods = optional(list(object({<br/>      name = string<br/>    })), [])<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->
