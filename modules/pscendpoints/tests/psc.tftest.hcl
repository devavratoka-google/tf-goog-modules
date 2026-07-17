# modules/pscendpoints/tests/psc.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}
mock_provider "google-beta" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project      = "test-project-123"
  network      = "projects/test-project-123/global/networks/test-vpc"
  address_name = "test-psc-endpoint"
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
# Test Run 1: Regional Connectivity Endpoint with Regional Address
# ==============================================================================
run "verify_regional_connectivity_endpoint" {
  command = plan

  variables {
    region                  = "us-central1"
    subnetwork              = "projects/test-project-123/regions/us-central1/subnetworks/test-subnet"
    create_regional_address = true
    target_google_api       = "storage.us-central1.rep.googleapis.com"
  }

  assert {
    condition     = length(module.addresses) == 1
    error_message = "Expected regional address module to be instantiated."
  }

  assert {
    condition     = google_network_connectivity_regional_endpoint.this[0].name == "test-psc-endpoint"
    error_message = "Regional endpoint name did not match address_name."
  }

  assert {
    condition     = google_network_connectivity_regional_endpoint.this[0].target_google_api == "storage.us-central1.rep.googleapis.com"
    error_message = "Regional endpoint target google API did not match input target_google_api."
  }
}

# ==============================================================================
# Test Run 2: Global Forwarding Rule (All APIs) with Global Address
# ==============================================================================
run "verify_global_forwarding_rule_all_apis" {
  command = plan

  variables {
    create_global_address = true
    target_google_api     = "all-apis"
  }

  assert {
    condition     = length(google_compute_global_address.this) == 1
    error_message = "Expected global address resource to be created."
  }

  assert {
    condition     = google_compute_global_forwarding_rule.google_apis[0].name == "test-psc-endpoint-fr"
    error_message = "Global forwarding rule name did not match expected value."
  }

  assert {
    condition     = google_compute_global_forwarding_rule.google_apis[0].target == "all-apis"
    error_message = "Global forwarding rule target did not match 'all-apis'."
  }
}
