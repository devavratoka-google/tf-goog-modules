# modules/lb/tcp_routing/tests/tcp_routing.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}
mock_provider "google-beta" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  name            = "test-tcp-proxy"
  region          = "us-central1"
  backend_service = "projects/test-project/regions/us-central1/backendServices/test-backend-service"
}

# ==============================================================================
# Test Run 1: Verify Basic Region Target TCP Proxy
# ==============================================================================
run "verify_basic_tcp_proxy" {
  command = plan

  assert {
    condition     = google_compute_region_target_tcp_proxy.this.name == "test-tcp-proxy"
    error_message = "Target TCP proxy name did not match input name."
  }

  assert {
    condition     = google_compute_region_target_tcp_proxy.this.region == "us-central1"
    error_message = "Target TCP proxy region did not match input region."
  }

  assert {
    condition     = google_compute_region_target_tcp_proxy.this.backend_service == "projects/test-project/regions/us-central1/backendServices/test-backend-service"
    error_message = "Backend service link did not match input link."
  }

  assert {
    condition     = google_compute_region_target_tcp_proxy.this.proxy_header == "NONE"
    error_message = "Default proxy header did not match NONE."
  }
}

# ==============================================================================
# Test Run 2: Verify Proxy Header Override
# ==============================================================================
run "verify_custom_proxy_header" {
  command = plan

  variables {
    proxy_header = "PROXY_V1"
  }

  assert {
    condition     = google_compute_region_target_tcp_proxy.this.proxy_header == "PROXY_V1"
    error_message = "Proxy header override failed."
  }
}
