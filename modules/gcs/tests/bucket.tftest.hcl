# modules/gcs/tests/bucket.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
# Since this is a unit test, we mock the "google" provider. 
# This prevents Terraform from attempting to connect to GCP APIs or verify credentials.
mock_provider "google" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
# Setup global variables for the test runs. We supply valid governance labels
# globally so they don't trigger failures in the nested label_governance module.
variables {
  project_id = "test-project-123"
  location   = "us-central1"
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
# Test Run 1: Verify Bucket Name Validation Rule (Expect Failure)
# ==============================================================================
# This run validates that naming rules are correctly enforced.
# We pass an invalid bucket name and expect the 'name' variable validation to catch it.
run "verify_bucket_name_validation_fails" {
  command = plan

  variables {
    # Invalid name (must start with 'gcp-')
    name = "invalid-bucket-name"
  }

  # We declare that we expect the validation of the 'name' input variable to fail.
  expect_failures = [
    var.name
  ]
}

# ==============================================================================
# Test Run 2: Verify Successful Plan with Valid Inputs
# ==============================================================================
# In this block, we supply valid inputs and assert that the plan succeeds
# and that resource attributes are correctly mapped.
run "verify_bucket_succeeds_with_valid_name" {
  command = plan

  variables {
    # Valid name starting with 'gcp-'
    name = "gcp-governed-test-bucket"
  }

  # Assertions verify that the HCL logic correctly sets resource attributes
  assert {
    condition     = google_storage_bucket.bucket.name == "gcp-governed-test-bucket"
    error_message = "Storage bucket name did not match the input name."
  }

  assert {
    condition     = google_storage_bucket.bucket.project == "test-project-123"
    error_message = "Storage bucket project ID did not match the input project_id."
  }

  assert {
    condition     = google_storage_bucket.bucket.location == "us-central1"
    error_message = "Storage bucket location did not match the input location."
  }
}

# ==============================================================================
# Test Run 3: Verify Custom Configuration (Versioning, Storage Class, Force Destroy)
# ==============================================================================
# In this block, we override the default values for versioning, storage class,
# and force destroy to verify that they are mapped correctly to the resource attributes.
run "verify_custom_configuration" {
  command = plan

  variables {
    name          = "gcp-custom-test-bucket"
    versioning    = false
    force_destroy = true
    storage_class = "STANDARD"
  }

  assert {
    condition     = google_storage_bucket.bucket.versioning[0].enabled == false
    error_message = "Storage bucket versioning should be disabled."
  }

  assert {
    condition     = google_storage_bucket.bucket.force_destroy == true
    error_message = "Storage bucket force_destroy should be enabled."
  }

  assert {
    condition     = google_storage_bucket.bucket.storage_class == "STANDARD"
    error_message = "Storage bucket storage class did not match Standard."
  }
}

# ==============================================================================
# [DEMO] Test Run 4: Demonstration of a Failing Test Case (Commented Out)
# ==============================================================================
# Uncomment this run block to demonstrate how Terraform reports test failures.
#
# run "verify_failure_example" {
#   command = plan
# 
#   variables {
#     name = "gcp-failing-demo-bucket"
#   }
# 
#   # This assertion will fail because the location is configured as "us-central1"
#   # in the global variables block.
#   assert {
#     condition     = google_storage_bucket.bucket.location == "europe-west1"
#     error_message = "DEMO FAILURE: Storage bucket location was not europe-west1."
#   }
# }

