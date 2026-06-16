locals {
  workload_pool = coalesce(var.workload_pool, "${var.project_id}.svc.id.goog")

  # Not needed for DNS-only control plane access.
  # This block is only sent when IP-based endpoint access needs CIDR allowlists.
  master_authorized_networks_config = length(var.master_authorized_networks) > 0 || var.gcp_public_cidrs_access_enabled || var.private_endpoint_enforcement_enabled != null ? {
    cidr_blocks = var.master_authorized_networks

    gcp_public_cidrs_access_enabled      = var.gcp_public_cidrs_access_enabled
    private_endpoint_enforcement_enabled = var.private_endpoint_enforcement_enabled
  } : null
}

module "services" {
  source = "../../modules/services"

  project_id = var.project_id
}

module "gke_autopilot" {
  source = "../../modules/gke-autopilot-cluster"

  project_id = var.project_id
  name       = var.name
  location   = var.location
  network    = var.network
  subnetwork = var.subnetwork

  deletion_protection = var.env == "prod" ? true : false
  description         = var.description
  resource_labels     = var.resource_labels

  ip_allocation_policy              = var.ip_allocation_policy
  master_authorized_networks_config = local.master_authorized_networks_config
  private_cluster_config            = var.private_cluster_config
  control_plane_endpoints_config    = var.control_plane_endpoints_config
  workload_identity_config          = { workload_pool = local.workload_pool }
  release_channel                   = var.release_channel
  vertical_pod_autoscaling          = var.vertical_pod_autoscaling
  logging_config                    = var.logging_config
  monitoring_config                 = var.monitoring_config
  addons_config                     = var.addons_config
  confidential_nodes                = var.confidential_nodes
  cost_management_config            = var.cost_management_config
  database_encryption               = var.database_encryption
  datapath_provider                 = var.datapath_provider
  enable_l4_ilb_subsetting          = var.enable_l4_ilb_subsetting
  gateway_api_config                = var.gateway_api_config
  maintenance_policy                = var.maintenance_policy
  node_locations                    = var.node_locations
  node_pool_auto_config             = var.node_pool_auto_config
  security_posture_config           = var.security_posture_config
  service_external_ips_config       = var.service_external_ips_config
  timeouts                          = var.timeouts

  depends_on = [
    module.services,
  ]
}
