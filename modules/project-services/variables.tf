variable "project_id" {
  type = string
}

variable "services" {
  description = "List of GCP service API identifiers to enable (e.g. [\"pubsub.googleapis.com\", \"run.googleapis.com\"])."
  type        = list(string)
}

variable "disable_on_destroy" {
  description = "Whether to disable the API when the resource is destroyed. Set to false for shared project APIs."
  type        = bool
  default     = false
}

variable "disable_dependent_services" {
  description = "Whether to disable dependent services when disabling this service."
  type        = bool
  default     = false
}

variable "service_identities" {
  description = "Map of service API => list of roles to grant to its service identity via google_project_service_identity."
  type        = map(list(string))
  default     = {}
}
