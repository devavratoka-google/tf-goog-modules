################ Start Compute Address ################

# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../label-governance"
  labels = coalesce(var.labels, {})
}

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
  labels       = module.label_governance.validated_labels
}

################ End Compute Address ################
