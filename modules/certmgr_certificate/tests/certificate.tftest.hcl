# modules/certmgr_certificate/tests/certificate.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project = "project-abc-01"
  name    = "test-regional-cert"
  domains = ["api.example.com"]
  labels = {
    environment = "dev"
    app         = "api"
  }
}

# ==============================================================================
# Test Run 1: Verify us-east4 regional certificate creation & naming convention
# ==============================================================================
run "verify_regional_cert_use4" {
  command = plan

  variables {
    location = "us-east4"
  }

  assert {
    condition     = google_certificate_manager_certificate.this.name == "test-regional-cert"
    error_message = "Certificate name did not match input."
  }

  assert {
    condition     = google_certificate_manager_certificate.this.location == "us-east4"
    error_message = "Certificate location did not match input."
  }

  assert {
    condition     = google_certificate_manager_certificate.this.project == "project-abc-01"
    error_message = "Certificate project did not match input."
  }
}

# ==============================================================================
# Test Run 2: Verify us-west1 regional certificate creation
# ==============================================================================
run "verify_regional_cert_usw1" {
  command = plan

  variables {
    location = "us-west1"
    name     = "test-regional-cert-usw1"
    domains  = ["west.example.com"]
  }

  assert {
    condition     = google_certificate_manager_certificate.this.location == "us-west1"
    error_message = "Certificate location did not match us-west1."
  }
}

# ==============================================================================
# Test Run 3: Verify explicit short_region override
# ==============================================================================
run "verify_custom_short_region" {
  command = plan

  variables {
    location     = "us-central1"
    short_region = "usc1"
    name         = "test-regional-cert-usc1"
    domains      = ["central.example.com"]
  }

  assert {
    condition     = google_certificate_manager_certificate.this.name == "test-regional-cert-usc1"
    error_message = "Certificate name did not match override input."
  }
}
