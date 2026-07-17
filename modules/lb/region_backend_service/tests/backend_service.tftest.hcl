# modules/lb/region_backend_service/tests/backend_service.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  name   = "test-backend-service"
  region = "us-central1"
}

# ==============================================================================
# Test Run 1: Verify Basic Region Backend Service
# ==============================================================================
run "verify_basic_backend_service" {
  command = plan

  assert {
    condition     = google_compute_region_backend_service.this.name == "test-backend-service"
    error_message = "Backend service name did not match input name."
  }

  assert {
    condition     = google_compute_region_backend_service.this.region == "us-central1"
    error_message = "Backend service region did not match input region."
  }

  assert {
    condition     = google_compute_region_backend_service.this.load_balancing_scheme == "INTERNAL_MANAGED"
    error_message = "Default load balancing scheme did not match INTERNAL_MANAGED."
  }

  assert {
    condition     = google_compute_region_backend_service.this.protocol == "HTTP"
    error_message = "Default protocol did not match HTTP."
  }
}

# ==============================================================================
# Test Run 2: Verify Backend Service with Backends and Log Config
# ==============================================================================
run "verify_custom_backend_service" {
  command = plan

  variables {
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config = {
      enable      = true
      sample_rate = 0.5
    }
    backends = [
      {
        group          = "projects/test-project-123/zones/us-central1-a/instanceGroups/test-ig"
        balancing_mode = "RATE"
        max_rate       = 100
      }
    ]
  }

  assert {
    condition     = google_compute_region_backend_service.this.load_balancing_scheme == "EXTERNAL_MANAGED"
    error_message = "Load balancing scheme override failed."
  }

  assert {
    condition     = length(google_compute_region_backend_service.this.backend) == 1
    error_message = "Expected exactly one backend resource block."
  }

  assert {
    condition     = google_compute_region_backend_service.this.log_config[0].enable == true
    error_message = "Expected log config to be enabled."
  }
}
