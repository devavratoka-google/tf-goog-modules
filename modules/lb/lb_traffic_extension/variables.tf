variable "name" {
  description = "Name of the LbTrafficExtension resource."
  type        = string
}

variable "description" {
  description = "A human-readable description of the resource."
  type        = string
  default     = null
}

variable "location" {
  description = "The location of the traffic extension."
  type        = string
}

variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
  default     = null
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme of the traffic extension. E.g., INTERNAL_MANAGED, EXTERNAL_MANAGED."
  type        = string
}

variable "forwarding_rules" {
  description = "A list of references to the forwarding rules to which this traffic extension is attached."
  type        = list(string)
}

variable "extension_chains" {
  description = "A list of extension chains containing match conditions and extensions."
  type = list(object({
    name = string
    match_condition = object({
      cel_expression = string
    })
    extensions = list(object({
      name             = string
      authority        = optional(string)
      service          = string
      timeout          = optional(string)
      fail_open        = optional(bool)
      forward_headers  = optional(list(string))
      supported_events = optional(list(string))
      metadata         = optional(map(string))
    }))
  }))
}

variable "labels" {
  description = "Labels to apply to the resource."
  type        = map(string)
  default     = {}
}
