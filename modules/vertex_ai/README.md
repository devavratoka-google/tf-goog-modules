# Vertex AI Module (Model Garden Support)

This module deploys Google Cloud Vertex AI resources supporting online prediction Endpoints and Model Garden foundation model deployment (e.g., Anthropic Claude, Llama 3, Mistral, or custom models).

## Usage

```hcl
module "vertex_ai" {
  source                = "./modules/vertex_ai"
  project_id            = "my-project-id"
  region                = "us-east4"
  endpoint_display_name = "claude-3-5-sonnet-endpoint"
  endpoint_description  = "Online serving endpoint for Anthropic Claude 3.5 Sonnet deployment"

  create_model          = true
  model_display_name    = "claude-3-5-sonnet-model"
  artifact_uri          = "gs://vertex-model-garden-public-us/anthropic/claude-3-5-sonnet"
  container_spec = {
    image_uri = "us-docker.pkg.dev/vertex-ai/vertex-vision-model-garden-dockers/pytorch-peft-serve:20240126_0936_RC00"
    env = [
      {
        name  = "MODEL_ID"
        value = "anthropic/claude-3-5-sonnet@20240620"
      }
    ]
  }
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_vertex_ai_endpoint.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_endpoint) | resource |
| [google_vertex_ai_model.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_model) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region/location where the Vertex AI resources will be deployed. | `string` | `"us-central1"` | no |
| <a name="input_endpoint_display_name"></a> [endpoint\_display\_name](#input\_endpoint\_display\_name) | The display name of the Vertex AI Endpoint. | `string` | n/a | yes |
| <a name="input_endpoint_name"></a> [endpoint\_name](#input\_endpoint\_name) | The resource name of the Endpoint. | `string` | `null` | no |
| <a name="input_endpoint_description"></a> [endpoint\_description](#input\_endpoint\_description) | An optional description of the Vertex AI Endpoint. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels in key:value format to apply to Vertex AI resources. | `map(string)` | `{}` | no |
| <a name="input_network"></a> [network](#input\_network) | The full VPC network URI for private endpoints. | `string` | `null` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | The Cloud KMS key name to use for encryption. | `string` | `null` | no |
| <a name="input_create_model"></a> [create\_model](#input\_create\_model) | Whether to upload/register a Vertex AI Model (e.g., from Model Garden). | `bool` | `true` | no |
| <a name="input_model_display_name"></a> [model\_display\_name](#input\_model\_display\_name) | The display name of the Vertex AI Model. | `string` | `null` | no |
| <a name="input_model_description"></a> [model\_description](#input\_model\_description) | An optional description of the Vertex AI Model. | `string` | `null` | no |
| <a name="input_artifact_uri"></a> [artifact\_uri](#input\_artifact\_uri) | The GCS URI of the model artifact directory. | `string` | `null` | no |
| <a name="input_container_spec"></a> [container\_spec](#input\_container\_spec) | Container specification for serving the model via Model Garden. | `object(...)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_id"></a> [endpoint\_id](#output\_endpoint\_id) | The resource ID of the Vertex AI Endpoint. |
| <a name="output_endpoint_name"></a> [endpoint\_name](#output\_endpoint\_name) | The resource name (ID) of the Vertex AI Endpoint. |
| <a name="output_endpoint_display_name"></a> [endpoint\_display\_name](#output\_endpoint\_display\_name) | The display name of the Vertex AI Endpoint. |
| <a name="output_model_id"></a> [model\_id](#output\_model\_id) | The resource ID of the Vertex AI Model. |
| <a name="output_model_name"></a> [model\_name](#output\_model\_name) | The resource name of the Vertex AI Model. |
<!-- END_TF_DOCS -->
