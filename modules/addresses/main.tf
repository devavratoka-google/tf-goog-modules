################ Start Compute Address ################

resource "google_compute_address" "this" {
  name         = var.name
  description  = var.description
  address      = var.address
  address_type = var.address_type
  purpose      = var.purpose
  network      = var.network
  subnetwork   = var.subnetwork
  region       = var.region
  project      = var.project
}

################ End Compute Address ################
