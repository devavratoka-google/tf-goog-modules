variable "name" {
  description = "A user-specified name for the certificate."
  type        = string
}

variable "project" {
  description = "The ID of the project where the certificate and issuance config reside."
  type        = string
}

variable "location" {
  description = "The regional location where the certificate will be created (e.g., 'us-east4', 'us-west1')."
  type        = string
}

variable "domains" {
  description = "The list of domains for which this managed certificate should be issued."
  type        = list(string)
}

variable "description" {
  description = "An optional description of the certificate."
  type        = string
  default     = null
}

variable "labels" {
  description = "A map of labels to assign to the certificate."
  type        = map(string)
  default     = {}
}

variable "scope" {
  description = "The scope of the certificate (e.g., 'DEFAULT', 'EDGE_CACHE', 'ALL_REGIONS'). Defaults to null for regional default."
  type        = string
  default     = null
}

variable "dns_authorizations" {
  description = "The DNS authorizations to use for this managed certificate, if applicable."
  type        = list(string)
  default     = null
}

variable "short_region" {
  description = "Optional override for the 4-character region code (e.g., 'use4', 'usw1'). If omitted, automatically derived from location."
  type        = string
  default     = null
}

variable "issuance_config_name" {
  description = "Optional override for the Certificate Manager Issuance Config resource name. If omitted, defaults to '<project>-issuance-config-<short_region>'."
  type        = string
  default     = null
}
