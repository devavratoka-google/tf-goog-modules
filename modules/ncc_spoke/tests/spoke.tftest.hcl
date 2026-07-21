# modules/ncc_spoke/tests/spoke.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}
mock_provider "google-beta" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  name        = "test-spoke"
  hub         = "projects/test-project-123/locations/global/hubs/test-hub"
  location    = "us-central1"
  description = "Test connectivity spoke"
  group       = "default"
  project     = "test-project-123"

  linked_interconnect_attachments   = {}
  linked_vpn_tunnels                = {}
  linked_vpc_network                = {}
  linked_producer_vpc_network       = {}
  linked_router_appliance_instances = {}

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
# Test Run 1: Verify Successful Plan with Valid Inputs
# ==============================================================================
run "verify_spoke_succeeds_with_valid_inputs" {
  command = plan

  assert {
    condition     = google_network_connectivity_spoke.this.name == "test-spoke"
    error_message = "Spoke name did not match input name."
  }

  assert {
    condition     = google_network_connectivity_spoke.this.hub == "projects/test-project-123/locations/global/hubs/test-hub"
    error_message = "Spoke hub did not match input hub URI."
  }

  assert {
    condition     = google_network_connectivity_spoke.this.location == "us-central1"
    error_message = "Spoke location did not match input location."
  }

  assert {
    condition     = google_network_connectivity_spoke.this.project == "test-project-123"
    error_message = "Spoke project did not match input project ID."
  }
}

# ==============================================================================
# Test Run 2: Verify Dynamic Blocks Configuration
# ==============================================================================
run "verify_spoke_with_vpc_network" {
  command = plan

  variables {
    linked_vpc_network = {
      vpc_link = {
        uri                   = "projects/test-project-123/global/networks/test-vpc"
        exclude_export_ranges = ["10.0.0.0/8"]
        include_export_ranges = []
      }
    }
  }

  assert {
    condition     = length(google_network_connectivity_spoke.this.linked_vpc_network) == 1
    error_message = "Expected one linked VPC network connection."
  }

  assert {
    condition     = google_network_connectivity_spoke.this.linked_vpc_network[0].uri == "projects/test-project-123/global/networks/test-vpc"
    error_message = "Linked VPC network URI did not match input."
  }

  assert {
    condition     = google_network_connectivity_spoke.this.linked_vpc_network[0].exclude_export_ranges[0] == "10.0.0.0/8"
    error_message = "Linked VPC network exclude_export_ranges did not match input."
  }
}
