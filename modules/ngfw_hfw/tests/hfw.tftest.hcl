# modules/ngfw_hfw/tests/hfw.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  parent                 = "folders/123456789"
  short_name             = "test-hfw-policy"
  description            = "Test Hierarchical Firewall Policy"
  fw_policy_associations = {}
}

# ==============================================================================
# Test Run 1: Basic Firewall Policy Creation
# ==============================================================================
run "verify_policy_creation" {
  command = plan

  assert {
    condition     = google_compute_firewall_policy.this.short_name == "test-hfw-policy"
    error_message = "Firewall policy short name did not match input."
  }

  assert {
    condition     = google_compute_firewall_policy.this.parent == "folders/123456789"
    error_message = "Firewall policy parent did not match input."
  }
}

# ==============================================================================
# Test Run 2: Firewall Policy Rules
# ==============================================================================
run "verify_policy_rules" {
  command = plan

  variables {
    fw_policy_rules = {
      ingress_rule = {
        priority    = 1000
        direction   = "INGRESS"
        action      = "allow"
        description = "Allow TCP 80 and 443"
        match = {
          src_ip_ranges = ["10.0.0.0/8"]
          layer4_configs = [
            {
              ip_protocol = "tcp"
              ports       = ["80", "443"]
            }
          ]
        }
      }
    }
  }

  assert {
    condition     = length(google_compute_firewall_policy_rule.this) == 1
    error_message = "Expected exactly one firewall policy rule."
  }

  assert {
    condition     = google_compute_firewall_policy_rule.this["ingress_rule"].priority == 1000
    error_message = "Policy rule priority did not match input."
  }

  assert {
    condition     = google_compute_firewall_policy_rule.this["ingress_rule"].action == "allow"
    error_message = "Policy rule action did not match input."
  }
}
