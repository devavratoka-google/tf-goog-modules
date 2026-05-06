locals {
  project_id              = "<project_id>"
  primary_region          = "us-central1"
  secondary_region        = "us-east4"
  primary_region_zonea    = "us-central1-a"
  secondary_region_zonea  = "us-east4-a"
  primary_region_eu       = "europe-west3"
  primary_region_eu_zonea = "europe-west3-a"
  service_account_email   = "${data.google_project.project_int_demo.number}-compute@developer.gserviceaccount.com"
  service_account_scopes  = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append", "https://www.googleapis.com/auth/cloud-platform"]
}
