# modules/service_directory/tests/service_directory.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}
mock_provider "google-beta" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project_id   = "test-project-123"
  location     = "us-east4"
  namespace_id = "test-namespace"
  services = {
    "s3-service" = {
      metadata = { environment = "test" }
    }
  }
  endpoints = {
    "s3-endpoint" = {
      service_id = "s3-service"
      address    = "10.0.0.10"
      port       = 443
    }
  }
}

# ==============================================================================
# Test Run 1: Verify Service Directory Resources Creation
# ==============================================================================
run "verify_service_directory" {
  command = plan

  assert {
    condition     = google_service_directory_namespace.namespace.namespace_id == "test-namespace"
    error_message = "Namespace ID did not match input."
  }

  assert {
    condition     = google_service_directory_namespace.namespace.location == "us-east4"
    error_message = "Location did not match input."
  }

  assert {
    condition     = length(google_service_directory_service.service) == 1
    error_message = "Expected exactly one service resource created."
  }

  assert {
    condition     = google_service_directory_endpoint.endpoint["s3-endpoint"].port == 443
    error_message = "Endpoint default port did not match 443."
  }
}
