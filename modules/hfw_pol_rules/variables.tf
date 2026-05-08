// Cloud NGFW Hierarchical Firewall Policy Variables

variable "parent" {
  type        = string
  description = "(Required) The parent of the firewall policy."
}

variable "short_name" {
  type        = string
  description = "(Required) User-provided name of the Organization firewall policy. The name should be unique in the organization in which the firewall policy is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "description" {
  type        = string
  description = "An optional description of this resource. Provide this property when you create the resource."
}

// Cloud NGFW Hierarchical Firewall Policy Associations Variables

variable "fw_policy_associations" {
  type = map(object({
    attachment_target = string
    association_name  = string
  }))
  description = "The list of firewall policy associations."
}

// Cloud NGFW Hierarchical Firewall Policy Rule Variables

variable "fw_policy_rules" {
  description = "List of Ingress/Egress rules"
  type = map(object({
    priority                = number
    direction               = string
    action                  = string // "allow", "deny", "goto_next" and "apply_security_profile_group"
    rule_name               = optional(string)
    disabled                = optional(bool)
    description             = optional(string)
    enable_logging          = optional(bool)
    target_service_accounts = optional(list(string), [])
    target_resources        = optional(list(string), [])
    security_profile_group  = optional(string, null)
    tls_inspect             = optional(bool, false)
    target_secure_tags      = optional(list(string), [])
    match = object({
      src_ip_ranges             = optional(list(string), [])
      src_fqdns                 = optional(list(string), [])
      src_region_codes          = optional(list(string), [])
      src_threat_intelligences  = optional(list(string), [])
      src_address_groups        = optional(list(string), [])
      dest_ip_ranges            = optional(list(string), [])
      dest_fqdns                = optional(list(string), [])
      dest_region_codes         = optional(list(string), [])
      dest_threat_intelligences = optional(list(string), [])
      dest_address_groups       = optional(list(string), [])
      src_secure_tags           = optional(list(string), [])
      layer4_configs = optional(list(object({
        ip_protocol = string
        ports       = optional(list(string), [])
        }))
      )
    })
  }))
  default = {}
}