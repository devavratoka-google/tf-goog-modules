project_id = "infra-proj-id"
env        = "dev"
name       = "gke-autopilot-private-2"
location   = "us-central1"

network    = "tf-vpc-01"
subnetwork = "tf-vpc-01-sn-usc1"

description = "Private GKE Autopilot cluster"

resource_labels = {
  environment = "dev"
  managed_by  = "terraform"
  workload    = "gke-autopilot"
}

ip_allocation_policy = {
  cluster_secondary_range_name  = "gke-pods"
  services_secondary_range_name = "gke-services"
}


# Not needed while the cluster uses only the DNS endpoint.
# Authorized networks apply to IP-based control plane endpoints.
# master_authorized_networks = [
#   {
#     display_name = "vpc"
#     cidr_block   = "192.168.100.0/24"
#   }
# ]

private_cluster_config = {
  enable_private_nodes = true

  # GKE keeps this legacy private-cluster flag true for private nodes.
  # Actual public/private IP endpoints are disabled in ip_endpoints_config below.
  enable_private_endpoint = true
}

control_plane_endpoints_config = {
  dns_endpoint_config = {
    allow_external_traffic = true
  }

  # IP-based public/private control plane endpoints disabled.
  # This removes access through Public endpoint and Private endpoint IPs.
  ip_endpoints_config = {
    enabled = false
  }
}

release_channel = {
  channel = "REGULAR"
}

logging_config = {
  enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
}

monitoring_config = {
  enable_components = ["SYSTEM_COMPONENTS"]
}

cost_management_config = {
  enabled = true
}

security_posture_config = {
  mode               = "BASIC"
  vulnerability_mode = "VULNERABILITY_BASIC"
}

service_external_ips_config = {
  enabled = false
}
