variable "project_id" {
  type = string
}

variable "location" {
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
  description = "Reasoning Engine spec. package_spec.python_version and package_spec.pickle_object_gcs_uri are required."
  type = object({
    package_spec = object({
      python_version            = string
      pickle_object_gcs_uri     = optional(string)
      dependency_files_gcs_uri  = optional(list(string), [])
      requirements_gcs_uri      = optional(string)
    })
    class_methods = optional(list(object({
      name = string
    })), [])
  })
}
