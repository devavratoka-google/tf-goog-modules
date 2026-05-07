################ Start DNS Policy ################

resource "google_dns_policy" "this" {
  name                      = var.name
  enable_inbound_forwarding = var.enable_inbound_forwarding
  enable_logging            = var.enable_logging
  
  dynamic "networks" {
    for_each = var.networks
    content {
      network_url = networks.value
    }
  }
  
  project = var.project
}

################ End DNS Policy ################
