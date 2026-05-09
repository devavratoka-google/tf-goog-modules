# Global Network Firewall Policy

resource "google_compute_network_firewall_policy" "this" {
  name        = var.nw_fw_policy_name
  description = var.nw_fw_policy_description
  project     = var.nw_fw_policy_project
}

# Global Network Firewall Association

resource "google_compute_network_firewall_policy_association" "this" {
  depends_on        = [google_compute_network_firewall_policy.this]
  for_each          = var.association_targets
  name              = "${google_compute_network_firewall_policy.this.name}-association-${each.key}"
  attachment_target = each.value
  firewall_policy   = google_compute_network_firewall_policy.this.name
  project           = google_compute_network_firewall_policy.this.project
}

# Global Network Firewall Policy Rule

# TODO: change resource name from 'rules' to 'this'

resource "google_compute_network_firewall_policy_rule" "rules" {
  depends_on              = [google_compute_network_firewall_policy.this]
  for_each                = var.nw_fw_policy_rules
  action                  = each.value.action
  direction               = each.value.direction
  firewall_policy         = google_compute_network_firewall_policy.this.name
  priority                = each.key
  project                 = google_compute_network_firewall_policy.this.project
  description             = each.value.description
  disabled                = each.value.disabled
  enable_logging          = each.value.enable_logging
  rule_name               = each.key
  security_profile_group  = each.value.security_profile_group
  target_service_accounts = each.value.target_service_accounts
  tls_inspect             = each.value.tls_inspect

  dynamic "target_secure_tags" {
    for_each = each.value.target_service_accounts != null || each.value.target_secure_tags == null ? [] : toset(each.value.target_secure_tags)
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
    dest_ip_ranges            = lookup(each.value.match, "dest_ip_ranges", []) # == null ? [] : lookup(each.value.match, "dest_ip_ranges", [])
    dest_fqdns                = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_fqdns", []) : []
    dest_region_codes         = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_region_codes", []) : []
    dest_threat_intelligences = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_threat_intelligences", []) : []
    dest_address_groups       = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_address_groups", []) : []

    dynamic "src_secure_tags" {
      for_each = each.value.direction != "INGRESS" || each.value.match.src_secure_tags == null ? [] : toset(each.value.match.src_secure_tags)
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
}