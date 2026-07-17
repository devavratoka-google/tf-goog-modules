# modules/dns/tests/dns.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project  = "test-project-123"
  name     = "test-dns-zone"
  dns_name = "test.example.com."
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
# Test Run 1: Public Zone Creation
# ==============================================================================
run "verify_public_zone" {
  command = plan

  variables {
    visibility = "public"
  }

  assert {
    condition     = google_dns_managed_zone.this.name == "test-dns-zone"
    error_message = "DNS zone name did not match input."
  }

  assert {
    condition     = google_dns_managed_zone.this.dns_name == "test.example.com."
    error_message = "DNS zone dns_name did not match input."
  }

  assert {
    condition     = google_dns_managed_zone.this.visibility == "public"
    error_message = "DNS zone visibility did not match input."
  }
}

# ==============================================================================
# Test Run 2: Private Zone with Networks
# ==============================================================================
run "verify_private_zone_with_networks" {
  command = plan

  variables {
    visibility = "private"
    networks   = ["https://www.googleapis.com/compute/v1/projects/test-project-123/global/networks/test-vpc"]
  }

  assert {
    condition     = google_dns_managed_zone.this.visibility == "private"
    error_message = "DNS zone visibility did not match 'private'."
  }

  assert {
    condition     = length(google_dns_managed_zone.this.private_visibility_config) == 1
    error_message = "Expected private_visibility_config block to be defined."
  }
}

# ==============================================================================
# Test Run 3: Record Sets Creation
# ==============================================================================
run "verify_record_sets" {
  command = plan

  variables {
    record_sets = {
      a_record = {
        name    = "www.test.example.com."
        type    = "A"
        ttl     = 300
        rrdatas = ["10.0.0.1"]
      }
    }
  }

  assert {
    condition     = length(google_dns_record_set.this) == 1
    error_message = "Expected exactly one DNS record set."
  }

  assert {
    condition     = google_dns_record_set.this["a_record"].type == "A"
    error_message = "Record set type did not match input."
  }
}
