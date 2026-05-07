variable "project" {
  description = "The ID of the project where the DNS resources will be created"
  type        = string
}

variable "name" {
  type        = string
  description = "The name of the managed zone"
}

variable "dns_name" {
  type        = string
  description = "The DNS name of this managed zone, for example \"example.com.\""
}

variable "description" {
  type        = string
  description = "A description of this managed zone"
  default     = "Managed by Terraform"
}

variable "visibility" {
  type        = string
  description = "The zone's visibility: public or private"
  default     = "private"
}

variable "networks" {
  type        = list(string)
  description = "For private zones, the list of VPC networks that can see this zone"
  default     = []
}

variable "forwarding_config" {
  type = object({
    target_name_servers = list(object({
      ipv4_address    = string
      forwarding_path = string
    }))
  })
  description = "The presence of this field indicates that outbound forwarding is enabled"
  default     = null
}

variable "peering_config" {
  type = object({
    target_network = string
  })
  description = "The presence of this field indicates that DNS peering is enabled"
  default     = null
}

variable "record_sets" {
  type = map(object({
    name    = string
    type    = string
    ttl     = number
    rrdatas = list(string)
  }))
  description = "Map of record sets to create in the zone"
  default     = {}
}
