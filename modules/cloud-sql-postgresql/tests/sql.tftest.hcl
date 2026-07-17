# modules/cloud-sql-postgresql/tests/sql.tftest.hcl

# ==============================================================================
# Provider Mocking
# ==============================================================================
mock_provider "google" {}
mock_provider "google-beta" {}

# ==============================================================================
# Global Test Variables
# ==============================================================================
variables {
  project_id       = "test-project-123"
  name             = "test-postgres-instance"
  database_version = "POSTGRES_15"
  zone             = "us-central1-a"
  user_labels = {
    application_id      = "app-999"
    environment         = "dev"
    business_unit       = "engineering"
    data_classification = "confidential"
    owner_team          = "sre"
    managed_by          = "terraform"
  }
}

# ==============================================================================
# Test Run 1: Verify Basic Cloud SQL Instance
# ==============================================================================
run "verify_basic_sql_instance" {
  command = plan

  assert {
    condition     = google_sql_database_instance.default.name == "test-postgres-instance"
    error_message = "SQL database instance name did not match input name."
  }

  assert {
    condition     = google_sql_database_instance.default.database_version == "POSTGRES_15"
    error_message = "SQL database version did not match input."
  }

  assert {
    condition     = google_sql_database_instance.default.settings[0].tier == "db-f1-micro"
    error_message = "SQL database tier did not match default tier."
  }
}

# ==============================================================================
# Test Run 2: Verify Custom Configuration
# ==============================================================================
run "verify_custom_sql_instance" {
  command = plan

  variables {
    tier              = "db-custom-2-7680"
    availability_type = "REGIONAL"
    backup_configuration = {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }
  }

  assert {
    condition     = google_sql_database_instance.default.settings[0].tier == "db-custom-2-7680"
    error_message = "SQL database tier override failed."
  }

  assert {
    condition     = google_sql_database_instance.default.settings[0].availability_type == "REGIONAL"
    error_message = "SQL database availability type override failed."
  }

  assert {
    condition     = google_sql_database_instance.default.settings[0].backup_configuration[0].enabled == true
    error_message = "SQL database backup configuration enabled field failed to map."
  }
}
