# Global Network Firewall Policy Variables

variable "nw_fw_policy_name" {
  type        = string
  description = "(Required) User-provided name of the Network firewall policy. The name should be unique in the project in which the firewall policy is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "nw_fw_policy_description" {
  type        = string
  description = "An optional description of this resource. Provide this property when you create the resource."
}

variable "nw_fw_policy_project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

# Global Network Firewall Association

variable "association_targets" {
  type        = map(string)
  description = "(Required) The target that the firewall policy is attached to."
  default = {
    # "network-1" = "projects/project-id/global/networks/nw-id"
    # "network-2" = "projects/project-id/global/networks/nw-id"
  }
}

# Global Network Firewall Policy Rule Variables

variable "nw_fw_policy_rules" {
  type = map(object({
    action    = string // (Required) The Action to perform when the client connection triggers the rule. Valid actions are "allow", "deny", "goto_next" and "apply_security_profile_group".
    direction = string // (Required) The direction in which this rule applies. Possible values: INGRESS, EGRESS
    # priority                = number                 // (Required) An integer indicating the priority of a rule in the list. The priority must be a positive value between 0 and 2147483647. Rules are evaluated from highest to lowest priority where 0 is the highest priority and 2147483647 is the lowest prority.
    # project                 = string                 // The project for the resource
    description    = string // An optional description for this resource.
    disabled       = bool   // Denotes whether the firewall policy rule is disabled. When set to true, the firewall policy rule is not enforced and traffic behaves as if it did not exist. If this is unspecified, the firewall policy rule will be enabled.
    enable_logging = bool   // Denotes whether to enable logging for a particular rule. If logging is enabled, logs will be exported to the configured export destination in Stackdriver. Logs may be exported to BigQuery or Pub/Sub. Note: you cannot enable logging on "goto_next" rules.
    # rule_name               = string                 // An optional name for the rule. This field is not a unique identifier and can be updated.
    security_profile_group  = string                 // A fully-qualified URL of a SecurityProfileGroup resource. Example: https://networksecurity.googleapis.com/v1/organizations/{organizationId}/locations/global/securityProfileGroups/my-security-profile-group. It must be specified if action = 'apply_security_profile_group' and cannot be specified for other actions.
    target_service_accounts = list(string)           // A list of service accounts indicating the sets of instances that are applied with this rule.
    tls_inspect             = bool                   // Boolean flag indicating if the traffic should be TLS decrypted. It can be set only if action = 'apply_security_profile_group' and cannot be set for other actions.
    target_secure_tags      = optional(list(string)) // A list of secure tags that controls which instances the firewall rule applies to. If are specified, then the firewall rule applies only to instances in the VPC network that have one of those EFFECTIVE secure tags, if all the target_secure_tag are in INEFFECTIVE state, then this rule will be ignored. may not be set at the same time as . If neither nor are specified, the firewall rule applies to all instances on the specified network. Maximum number of target label tags allowed is 256.
    match = object({
      src_ip_ranges             = optional(list(string), []) // CIDR IP address range. Maximum number of source CIDR IP ranges allowed is 5000.
      src_fqdns                 = optional(list(string), []) // Domain names that will be used to match against the resolved domain name of source of traffic. Can only be specified if DIRECTION is ingress.
      src_region_codes          = optional(list(string), []) // The Unicode country codes whose IP addresses will be used to match against the source of traffic. Can only be specified if DIRECTION is ingress.
      src_threat_intelligences  = optional(list(string), []) // Name of the Google Cloud Threat Intelligence list.
      src_address_groups        = optional(list(string), []) // Address groups which should be matched against the traffic source. Maximum number of source address groups is 10. Source address groups is only supported in Ingress rules.
      dest_ip_ranges            = optional(list(string), []) // CIDR IP address range. Maximum number of destination CIDR IP ranges allowed is 5000.
      dest_fqdns                = optional(list(string), []) // Domain names that will be used to match against the resolved domain name of destination of traffic. Can only be specified if DIRECTION is egress.
      dest_region_codes         = optional(list(string), []) // The Unicode country codes whose IP addresses will be used to match against the source of traffic. Can only be specified if DIRECTION is egress.
      dest_threat_intelligences = optional(list(string), []) // Name of the Google Cloud Threat Intelligence list.
      dest_address_groups       = optional(list(string), []) // Address groups which should be matched against the traffic destination. Maximum number of destination address groups is 10. Destination address groups is only supported in Egress rules.
      src_secure_tags           = optional(list(string), []) // List of secure tag values, which should be matched at the source of the traffic. For INGRESS rule, if all the are INEFFECTIVE, and there is no , this rule will be ignored. Maximum number of source tag values allowed is 256.
      layer4_configs = map(object({
        ip_protocol = string       // The IP protocol to which this rule applies. The protocol type is required when creating a firewall rule. This value can either be one of the following well known protocol strings (tcp, udp, icmp, esp, ah, ipip, sctp), or the IP protocol number.
        ports       = list(string) // An optional list of ports to which this rule applies. This field is only applicable for UDP or TCP protocol. Each entry must be either an integer or a range. If not specified, this rule applies to connections through any port. Example inputs include: ``.
      }))
    })
  }))
  # default = {}
}