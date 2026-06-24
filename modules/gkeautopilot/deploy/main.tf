module "gkeautopilot" {
  source = "../"

  project_id = var.project_id
  env        = var.env
  name       = var.name
  location   = var.location

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy = var.ip_allocation_policy

  master_authorized_networks           = var.master_authorized_networks
  gcp_public_cidrs_access_enabled      = var.gcp_public_cidrs_access_enabled
  private_endpoint_enforcement_enabled = var.private_endpoint_enforcement_enabled
  private_cluster_config               = var.private_cluster_config
  control_plane_endpoints_config       = var.control_plane_endpoints_config
  workload_pool                        = var.workload_pool

  description     = var.description
  resource_labels = var.resource_labels

  release_channel             = var.release_channel
  vertical_pod_autoscaling    = var.vertical_pod_autoscaling
  logging_config              = var.logging_config
  monitoring_config           = var.monitoring_config
  addons_config               = var.addons_config
  confidential_nodes          = var.confidential_nodes
  cost_management_config      = var.cost_management_config
  database_encryption         = var.database_encryption
  datapath_provider           = var.datapath_provider
  enable_l4_ilb_subsetting    = var.enable_l4_ilb_subsetting
  gateway_api_config          = var.gateway_api_config
  maintenance_policy          = var.maintenance_policy
  node_locations              = var.node_locations
  node_pool_auto_config       = var.node_pool_auto_config
  security_posture_config     = var.security_posture_config
  service_external_ips_config = var.service_external_ips_config
  timeouts                    = var.timeouts
}
