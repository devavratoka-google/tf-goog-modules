variable "name" {
  description = "Name of the target TCP proxy."
  type        = string
}

variable "region" {
  description = "Region where the target TCP proxy resides."
  type        = string
}

variable "backend_service" {
  description = "The self_link or ID of the region backend service."
  type        = string
}

variable "description" {
  description = "An optional description of this resource."
  type        = string
  default     = null
}

variable "proxy_header" {
  description = "Specifies the type of proxy header to append before sending data to the backend. Options: NONE, PROXY_V1."
  type        = string
  default     = null
}
