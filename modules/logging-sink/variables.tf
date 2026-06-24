variable "project_id" {
  type = string
}

variable "name" {
  description = "Name of the log sink."
  type        = string
}

variable "destination" {
  description = "The destination URI. Examples: bigquery.googleapis.com/projects/P/datasets/D, storage.googleapis.com/my-bucket."
  type        = string
}

variable "filter" {
  description = "Cloud Logging filter expression. Empty string exports all logs."
  type        = string
  default     = ""
}

variable "description" {
  type    = string
  default = null
}

variable "disabled" {
  type    = bool
  default = false
}

variable "exclusions" {
  description = "Log exclusion filters."
  type = list(object({
    name        = string
    description = optional(string)
    filter      = string
    disabled    = optional(bool, false)
  }))
  default = []
}
