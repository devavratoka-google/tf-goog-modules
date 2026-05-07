terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=7.0.0"
    }
  }
  required_version = ">1.5.0"
}

provider "google" {
  project = var.env_project_id
  region  = local.primary_region
  zone    = local.primary_region_zonea
}