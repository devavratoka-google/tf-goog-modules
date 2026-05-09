// Cloud NGFW Hierarchical Firewall Policy

resource "google_compute_firewall_policy" "this" {
  parent      = var.parent
  short_name  = var.short_name
  description = var.description
}

// Cloud NGFW Hierarchical Firewall Policy Associations

resource "google_compute_firewall_policy_association" "this" {
  for_each          = var.fw_policy_associations
  firewall_policy   = google_compute_firewall_policy.this.id
  attachment_target = each.value.attachment_target
  name              = each.value.association_name
}

// Cloud NGFW Hierarchical Firewall Policy Rule

resource "google_compute_firewall_policy_rule" "this" {
  for_each        = var.fw_policy_rules
  firewall_policy = google_compute_firewall_policy.this.name
  description     = each.value.description
  priority        = each.value.priority
  enable_logging  = each.value.enable_logging
  action          = each.value.action
  direction       = each.value.direction
  disabled        = each.value.disabled

  dynamic "target_secure_tags" {
    for_each = each.value.target_secure_tags != [] ? toset(each.value.target_secure_tags) : []
    content {
      name = target_secure_tags.value
      #   state = target_secure_tags.value.state
    }
  }

  match {
    src_ip_ranges             = lookup(each.value.match, "src_ip_ranges", [])
    src_fqdns                 = each.value.direction == "INGRESS" ? lookup(each.value.match, "src_fqdns", []) : []
    src_region_codes          = each.value.direction == "INGRESS" ? lookup(each.value.match, "src_region_codes", []) : []
    src_threat_intelligences  = each.value.direction == "INGRESS" ? lookup(each.value.match, "src_threat_intelligences", []) : []
    src_address_groups        = each.value.direction == "INGRESS" ? lookup(each.value.match, "src_address_groups", []) : []
    dest_ip_ranges            = lookup(each.value.match, "dest_ip_ranges", [])
    dest_fqdns                = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_fqdns", []) : []
    dest_region_codes         = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_region_codes", []) : []
    dest_threat_intelligences = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_threat_intelligences", []) : []
    dest_address_groups       = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_address_groups", []) : []
    dynamic "src_secure_tags" {
      for_each = each.value.match.src_secure_tags != null ? toset(each.value.match.src_secure_tags) : []
      content {
        name = src_secure_tags.value
        # state = src_secure_tags.value.state
      }
    }
    dynamic "layer4_configs" {
      for_each = each.value.match.layer4_configs
      content {
        ip_protocol = layer4_configs.value.ip_protocol
        ports       = layer4_configs.value.ports
      }
    }
  }
  security_profile_group  = each.value.security_profile_group
  target_resources        = each.value.target_resources
  tls_inspect             = each.value.tls_inspect
  target_service_accounts = each.value.target_service_accounts
}