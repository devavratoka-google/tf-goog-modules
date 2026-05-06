resource "google_compute_interconnect_attachment" "this" {
  router                   = var.router
  name                     = var.name
  region                   = var.region
  project                  = var.project
  admin_enabled            = var.admin_enabled
  description              = var.description
  mtu                      = var.mtu
  edge_availability_domain = var.edge_availability_domain
  type                     = var.type
  vlan_tag8021q            = var.vlan_tag8021q
  encryption               = var.encryption
  labels                   = var.labels
}

resource "google_network_management_vpc_flow_logs_config" "this" {
  vpc_flow_logs_config_id = var.vpc_flow_logs_config_id
  location                = "global"
  project                 = google_compute_interconnect_attachment.this.project
  interconnect_attachment = google_compute_interconnect_attachment.this.id
  state                   = var.state
  aggregation_interval    = var.aggregation_interval
  description             = "VPC Flow Logs for ${google_compute_interconnect_attachment.this.name}"
  flow_sampling           = var.flow_sampling
  metadata                = var.metadata
  labels                  = var.flow_log_labels
}