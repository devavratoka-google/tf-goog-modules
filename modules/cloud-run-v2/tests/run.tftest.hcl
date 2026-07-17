# modules/cloud-run-v2/tests/run.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}
mock_provider "google-beta" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project_id = "test-project-123"
  name       = "test-cloudrun-service"
  region     = "us-central1"
  labels = {
    application_id      = "app-999"
    environment         = "dev"
    business_unit       = "engineering"
    data_classification = "confidential"
    owner_team          = "sre"
    managed_by          = "terraform"
  }
  containers = {
    web = {
      image = "gcr.io/test-project-123/web:latest"
    }
  }
}

# ==============================================================================
# Test Run 1: Verify Basic Service configuration
# ==============================================================================
run "verify_basic_service" {
  command = plan

  assert {
    condition     = google_cloud_run_v2_service.service[0].name == "test-cloudrun-service"
    error_message = "Cloud Run service name did not match input name."
  }

  assert {
    condition     = google_cloud_run_v2_service.service[0].location == "us-central1"
    error_message = "Cloud Run service region did not match input region."
  }

  assert {
    condition     = google_cloud_run_v2_service.service[0].project == "test-project-123"
    error_message = "Cloud Run service project did not match input project_id."
  }
}

# ==============================================================================
# Test Run 2: Verify Job configuration
# ==============================================================================
run "verify_job_creation" {
  command = plan

  variables {
    type = "JOB"
  }

  assert {
    condition     = length(google_cloud_run_v2_job.job) == 1
    error_message = "Expected Cloud Run job to be created when type is JOB."
  }

  assert {
    condition     = google_cloud_run_v2_job.job[0].name == "test-cloudrun-service"
    error_message = "Cloud Run job name did not match expected value."
  }
}
