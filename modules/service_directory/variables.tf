variable "project_id" {
  description = "The ID of the GCP project where the Service Directory resources will be created."
  type        = string
}

variable "location" {
  description = "The region or location for the Service Directory namespace."
  type        = string
}

variable "namespace_id" {
  description = "The ID of the Service Directory namespace."
  type        = string
}

variable "labels" {
  description = "Resource labels to apply to the namespace."
  type        = map(string)
  default     = {}
}

variable "services" {
  description = "A map of Service Directory services to create inside the namespace."
  type = map(object({
    metadata = optional(map(string), {})
  }))
  default = {}
}

variable "endpoints" {
  description = "A map of Service Directory endpoints to create inside the defined services."
  type = map(object({
    service_id = string
    address    = string
    port       = optional(number, 443)
    network    = optional(string, null)
    metadata   = optional(map(string), {})
  }))
  default = {}
}
