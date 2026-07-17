# modules/vpc/tests/vpc.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google-beta" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project_id   = "test-project-123"
  network_name = "test-vpc"
}

# ==============================================================================
# Test Run 1: Verify Basic VPC
# ==============================================================================
run "verify_basic_vpc" {
  command = plan

  assert {
    condition     = google_compute_network.this.name == "test-vpc"
    error_message = "VPC name did not match input network_name."
  }

  assert {
    condition     = google_compute_network.this.project == "test-project-123"
    error_message = "VPC project did not match input project_id."
  }

  assert {
    condition     = google_compute_network.this.auto_create_subnetworks == false
    error_message = "Default auto_create_subnetworks should be false."
  }

  assert {
    condition     = google_compute_network.this.routing_mode == "GLOBAL"
    error_message = "Default routing_mode should be GLOBAL."
  }
}

# ==============================================================================
# Test Run 2: Verify Custom VPC Configurations
# ==============================================================================
run "verify_custom_vpc" {
  command = plan

  variables {
    routing_mode                           = "REGIONAL"
    auto_create_subnetworks                = true
    delete_default_internet_gateway_routes = true
    mtu                                    = 1500
    bgp_best_path_selection_mode           = "STANDARD"
    bgp_always_compare_med                 = true
  }

  assert {
    condition     = google_compute_network.this.routing_mode == "REGIONAL"
    error_message = "VPC routing_mode did not match override."
  }

  assert {
    condition     = google_compute_network.this.auto_create_subnetworks == true
    error_message = "VPC auto_create_subnetworks did not match override."
  }

  assert {
    condition     = google_compute_network.this.delete_default_routes_on_create == true
    error_message = "VPC delete_default_routes_on_create did not match override."
  }

  assert {
    condition     = google_compute_network.this.mtu == 1500
    error_message = "VPC mtu did not match override."
  }

  assert {
    condition     = google_compute_network.this.bgp_best_path_selection_mode == "STANDARD"
    error_message = "VPC bgp_best_path_selection_mode did not match override."
  }
}
