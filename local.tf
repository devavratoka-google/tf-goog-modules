locals {
  primary_region         = "us-east4"
  secondary_region       = "us-west1"
  primary_region_zonea   = "us-east4-a"
  secondary_region_zonea = "us-west1-a"
  service_account_email  = "${data.google_project.infra-project.number}-compute@developer.gserviceaccount.com"
  service_account_scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append", "https://www.googleapis.com/auth/cloud-platform"]
}
