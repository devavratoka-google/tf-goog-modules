################ Variables for Vertex AI Endpoint ################

variable "project_id" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "region" {
  type        = string
  description = "(Required) The region/location where the Vertex AI resources will be deployed (e.g., 'us-central1')."
  default     = "us-central1"
}

variable "endpoint_name" {
  type        = string
  description = "(Optional) The resource name of the Endpoint."
  default     = null
}

variable "endpoint_display_name" {
  type        = string
  description = "(Required) The display name of the Vertex AI Endpoint."
}

variable "endpoint_description" {
  type        = string
  description = "(Optional) An optional description of the Vertex AI Endpoint."
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "(Optional) Labels in key:value format to apply to Vertex AI resources."
  default     = {}
}

variable "network" {
  type        = string
  description = "(Optional) The full VPC network URI for private endpoints."
  default     = null
}

variable "kms_key_name" {
  type        = string
  description = "(Optional) The Cloud KMS key name to use for encryption."
  default     = null
}

################ Variables for Vertex AI Model (Model Garden) ################

variable "create_model" {
  type        = bool
  description = "Whether to upload/register a Vertex AI Model (e.g., from Model Garden)."
  default     = true
}

variable "model_display_name" {
  type        = string
  description = "(Optional) The display name of the Vertex AI Model. Required if create_model is true."
  default     = null
}

variable "model_description" {
  type        = string
  description = "(Optional) An optional description of the Vertex AI Model."
  default     = null
}

variable "artifact_uri" {
  type        = string
  description = "(Optional) The GCS URI of the model artifact directory (e.g., 'gs://model-garden-artifacts/llama3')."
  default     = null
}

variable "container_spec" {
  type = object({
    image_uri = string
    command   = optional(list(string))
    args      = optional(list(string))
    env = optional(list(object({
      name  = string
      value = string
    })), [])
  })
  description = "(Optional) Container specification for serving the model via Model Garden or custom image."
  default     = null
}

variable "tag_bindings" {
  description = "Tag bindings for the Vertex AI Endpoint, in key => tag value id format."
  type        = map(string)
  default     = {}
}

