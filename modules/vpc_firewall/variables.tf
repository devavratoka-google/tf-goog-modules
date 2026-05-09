variable "vpc_firewall_rules" {
  type = map(object({
    name                    = string
    network                 = string
    project                 = string
    description             = string
    direction               = string
    disabled                = bool
    priority                = number
    ranges                  = list(string)
    source_tags             = list(string)
    source_service_accounts = list(string)
    target_tags             = list(string)
    target_service_accounts = list(string)
    log_config = object({
      metadata = string
    })
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
  }))
}