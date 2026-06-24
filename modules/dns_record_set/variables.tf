variable "project" {
  type        = string
  description = "The ID of the project where the DNS resources will be created"
  default     = null
}

variable "managed_zone" {
  type        = string
  description = "The name of the managed zone in which this record set will be created"
}

variable "name" {
  type        = string
  description = "The DNS name of this record set, e.g. www.example.com."
}

variable "type" {
  type        = string
  description = "The DNS record set type (A, AAAA, CNAME are allowed)."

  validation {
    condition     = contains(["A", "AAAA", "CNAME"], var.type)
    error_message = "Only A, AAAA, and CNAME record types are allowed."
  }
}

variable "ttl" {
  type        = number
  description = "The time-to-live of this record set (in seconds)"
  default     = 300
}

variable "rrdatas" {
  type        = list(string)
  description = "The string values for the record, e.g. IP addresses or CNAME targets"
  default     = []
}
