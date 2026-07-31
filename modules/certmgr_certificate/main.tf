################ Start Certificate Manager Certificate ################

# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../label-governance"
  labels = coalesce(var.labels, {})
}

locals {
  # Standard mapping from GCP regions to 4-character short region codes used by the customer naming convention.
  region_short_names = {
    "us-east1"    = "use1"
    "us-east4"    = "use4"
    "us-east5"    = "use5"
    "us-west1"    = "usw1"
    "us-west2"    = "usw2"
    "us-west3"    = "usw3"
    "us-west4"    = "usw4"
    "us-central1" = "usc1"
    "us-south1"   = "uss1"
  }

  # Derive short region code (e.g. 'use4') from location, or use explicit override if provided
  region_short_name = var.short_region != null ? var.short_region : lookup(local.region_short_names, var.location, var.location)

  # Follow customer naming convention: <project-id>-issuance-config-<region>
  issuance_config_name = var.issuance_config_name != null ? var.issuance_config_name : "${var.project}-issuance-config-${local.region_short_name}"
}

data "google_certificate_manager_certificate_issuance_config" "default" {
  name     = local.issuance_config_name
  location = var.location
  project  = var.project
}

resource "google_certificate_manager_certificate" "this" {
  name        = var.name
  description = var.description
  location    = var.location
  project     = var.project
  labels      = module.label_governance.validated_labels
  scope       = var.scope

  managed {
    domains            = var.domains
    issuance_config    = data.google_certificate_manager_certificate_issuance_config.default.id
    dns_authorizations = var.dns_authorizations
  }
}

################ End Certificate Manager Certificate ################
