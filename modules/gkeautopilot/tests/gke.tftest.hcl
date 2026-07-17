# modules/gkeautopilot/tests/gke.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}
mock_provider "google-beta" {
  mock_resource "google_container_cluster" {
    defaults = {
      control_plane_endpoints_config = [{
        dns_endpoint_config = [{
          endpoint = "dns-endpoint"
        }]
      }]
      master_auth = [{
        cluster_ca_certificate = "dummy-cert"
      }]
      private_cluster_config = [{
        private_endpoint = "private-endpoint"
      }]
    }
  }
}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project_id = "test-project-123"
  name       = "test-gke-cluster"
  location   = "us-central1"
  network    = "projects/test-project-123/global/networks/test-vpc"
  subnetwork = "projects/test-project-123/regions/us-central1/subnetworks/test-subnet"
  labels = {
    application_id      = "app-999"
    environment         = "dev"
    business_unit       = "engineering"
    data_classification = "confidential"
    owner_team          = "sre"
    managed_by          = "terraform"
  }
}

# ==============================================================================
# Test Run 1: Verify Basic GKE Autopilot Cluster
# ==============================================================================
run "verify_basic_cluster" {
  command = plan

  providers = {
    google      = google
    google-beta = google-beta
  }

  assert {
    condition     = google_container_cluster.main.name == "test-gke-cluster"
    error_message = "Cluster name did not match input."
  }

  assert {
    condition     = google_container_cluster.main.location == "us-central1"
    error_message = "Cluster location did not match input."
  }

  assert {
    condition     = google_container_cluster.main.enable_autopilot == true
    error_message = "Autopilot was not enabled on the cluster."
  }

  assert {
    condition     = google_container_cluster.main.network == "projects/test-project-123/global/networks/test-vpc"
    error_message = "Cluster network did not match input network."
  }

  assert {
    condition     = google_container_cluster.main.subnetwork == "projects/test-project-123/regions/us-central1/subnetworks/test-subnet"
    error_message = "Cluster subnetwork did not match input subnetwork."
  }
}

# ==============================================================================
# Test Run 2: Verify Custom Configuration
# ==============================================================================
run "verify_custom_cluster" {
  command = plan

  providers = {
    google      = google
    google-beta = google-beta
  }

  variables {
    description = "A custom description for GKE Autopilot"
    master_authorized_networks = [
      {
        display_name = "corp-vpn"
        cidr_block   = "192.168.1.0/24"
      }
    ]
  }

  assert {
    condition     = google_container_cluster.main.description == "A custom description for GKE Autopilot"
    error_message = "Cluster description override failed."
  }

  assert {
    condition     = length(google_container_cluster.main.master_authorized_networks_config[0].cidr_blocks) == 1
    error_message = "Expected exactly one master authorized network rule."
  }
}
