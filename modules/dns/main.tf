################ Start DNS Managed Zone ################

resource "google_dns_managed_zone" "this" {
  name        = var.name
  dns_name    = var.dns_name
  description = var.description
  visibility  = var.visibility

  dynamic "private_visibility_config" {
    for_each = var.visibility == "private" ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.networks
        content {
          network_url = networks.value
        }
      }
    }
  }

  dynamic "forwarding_config" {
    for_each = var.forwarding_config != null ? [var.forwarding_config] : []
    content {
      dynamic "target_name_servers" {
        for_each = forwarding_config.value.target_name_servers
        content {
          ipv4_address    = target_name_servers.value.ipv4_address
          forwarding_path = try(target_name_servers.value.forwarding_path, null)
        }
      }
    }
  }

  dynamic "peering_config" {
    for_each = var.peering_config != null ? [var.peering_config] : []
    content {
      target_network {
        network_url = peering_config.value.target_network
      }
    }
  }

  project = var.project
}

################ End DNS Managed Zone ################

################ Start DNS Record Sets ################

resource "google_dns_record_set" "this" {
  for_each = var.record_sets

  managed_zone = google_dns_managed_zone.this.name
  name         = each.value.name
  type         = each.value.type
  ttl          = each.value.ttl
  rrdatas      = each.value.rrdatas

  project = var.project
}

################ End DNS Record Sets ################
