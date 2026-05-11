resource "google_network_connectivity_hub" "this" {
  name            = var.name
  description     = var.description
  labels          = var.labels
  preset_topology = var.preset_topology
  #  policy_mode = var.policy_mode
  export_psc = var.export_psc
  project    = var.project
}

resource "google_network_connectivity_group" "this" {
  for_each    = var.ncc_groups
  hub         = google_network_connectivity_hub.this.id
  project     = google_network_connectivity_hub.this.project
  name        = each.key
  description = each.value.description

  dynamic "auto_accept" {
    for_each = length(each.value.auto_accept_projects) > 0 ? [1] : []
    content {
      auto_accept_projects = each.value.auto_accept_projects
    }
  }
}
