variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "display_name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "spec" {
  description = <<-EOT
    Optional Reasoning Engine spec. When null (the default), the engine is
    created with NO spec block — used when the engine serves only as a parent
    for Agent Engine sandbox children / Vertex AI Session Service persistence
    and hosts no deployed agent code. When set, it describes deployed agent
    code: package_spec.python_version is required and pickle_object_gcs_uri
    points at the pickled agent object in GCS.
  EOT
  type = object({
    package_spec = object({
      python_version           = string
      pickle_object_gcs_uri    = optional(string)
      dependency_files_gcs_uri = optional(list(string), [])
      requirements_gcs_uri     = optional(string)
    })
    class_methods = optional(list(object({
      name = string
    })), [])
  })
  default = null
}
