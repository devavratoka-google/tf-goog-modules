## Firewall Endpoint Variables

variable "name" {
  type        = string
  description = "(Required) The name of the firewall endpoint resource."
}

variable "parent" {
  type        = string
  description = "(Required) The name of the parent this firewall endpoint belongs to. Format: organizations/{organization_id}."
}

variable "location" {
  type        = string
  description = "(Required) The location (zone) of the firewall endpoint."
}

variable "billing_project_id" {
  type        = string
  description = "(Required) Project to bill on endpoint uptime usage."
}

variable "labels" {
  type        = map(string)
  description = "A map of key/value label pairs to assign to the resource."
}

## Firewall Endpoint Association Variables

variable "fw_ep_associations" {
  type = map(object({
    fw_ip_association_parent   = string
    network                    = string
    fw_ip_association_location = string
    fw_ep_association_labels   = map(string)
    tls_inspection_policy      = string
    disabled                   = bool
  }))
}