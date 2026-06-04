# ==============================================================================
# Vertex AI & Model Garden Configuration Variables (`vertex_ai.tfvars`)
# ==============================================================================
# This file is dedicated to configuring Google Cloud Vertex AI resources,
# specifically provisioning online prediction Endpoints and deploying Model Garden
# foundation models (e.g., Anthropic Claude, Llama 3, Mistral, Gemma, or custom models).
#
# Usage:
#   terraform plan -var-file="vertex_ai.tfvars"
#   terraform apply -var-file="vertex_ai.tfvars"
# ==============================================================================

vertex_ai_endpoints = {
  # "claude-3-5-sonnet-endpoint" = {
  #   region                = "us-east4"
  #   endpoint_display_name = "claude-3-5-sonnet-endpoint"
  #   endpoint_description  = "Online serving endpoint for Anthropic Claude 3.5 Sonnet Model Garden deployment"
  #   
  #   create_model          = true
  #   model_display_name    = "claude-3-5-sonnet-model"
  #   model_description     = "Anthropic Claude 3.5 Sonnet foundation model integrated via Vertex AI Model Garden"
  #   
  #   # Official Model Garden GCS artifact URI for Anthropic Claude serving configurations
  #   artifact_uri          = "gs://vertex-model-garden-public-us/anthropic/claude-3-5-sonnet"
  #
  #   container_spec = {
  #     # Official Vertex AI Model Garden pre-built container for foundation model serving
  #     image_uri = "us-docker.pkg.dev/vertex-ai/vertex-vision-model-garden-dockers/pytorch-peft-serve:20240126_0936_RC00"
  #     env = [
  #       {
  #         name  = "MODEL_ID"
  #         value = "anthropic/claude-3-5-sonnet@20240620"
  #       }
  #     ]
  #   }
  #
  #   labels = {
  #     environment    = "production"
  #     ai_workload    = "genai-customer-service"
  #     model_provider = "anthropic"
  #   }
  # }
}
