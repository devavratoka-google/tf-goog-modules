# modules/subnetworks/tests/subnetworks.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project                          = "test-project-123"
  network                          = "projects/test-project-123/global/networks/test-vpc"
  name                             = "test-subnet"
  description                      = "Test Subnetwork"
  ip_cidr_range                    = "10.0.1.0/24"
  reserved_internal_range          = null
  purpose                          = "PRIVATE"
  role                             = null
  private_ip_google_access         = true
  private_ipv6_google_access       = null
  region                           = "us-central1"
  stack_type                       = "IPV4_ONLY"
  ipv6_access_type                 = null
  external_ipv6_prefix             = null
  send_secondary_ip_range_if_empty = false
  secondary_ip_range               = {}
  log_config                       = null
}

# ==============================================================================
# Test Run 1: Basic Subnetwork Verification
# ==============================================================================
run "verify_basic_subnetwork" {
  command = plan

  assert {
    condition     = google_compute_subnetwork.this.name == "test-subnet"
    error_message = "Subnetwork name did not match input name."
  }

  assert {
    condition     = google_compute_subnetwork.this.ip_cidr_range == "10.0.1.0/24"
    error_message = "Subnetwork IP CIDR range did not match input range."
  }

  assert {
    condition     = google_compute_subnetwork.this.purpose == "PRIVATE"
    error_message = "Subnetwork purpose did not match input purpose."
  }

  assert {
    condition     = google_compute_subnetwork.this.private_ip_google_access == true
    error_message = "Subnetwork private_ip_google_access did not match input."
  }
}

# ==============================================================================
# Test Run 2: Subnetwork with Log Config
# ==============================================================================
run "verify_subnetwork_with_logs" {
  command = plan

  variables {
    log_config = {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
      metadata_fields      = []
      filter_expr          = "true"
    }
  }

  assert {
    condition     = length(google_compute_subnetwork.this.log_config) == 1
    error_message = "Expected log_config to be configured."
  }
}
