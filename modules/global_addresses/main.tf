# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../label-governance"
  labels = coalesce(var.labels, {})
}

resource "google_compute_global_address" "this" {
  name          = var.name
  address       = var.address
  description   = var.description
  labels        = module.label_governance.validated_labels
  ip_version    = var.ip_version
  prefix_length = var.prefix_length
  address_type  = var.address_type
  purpose       = var.purpose
  network       = var.network
  project       = var.project
}

resource "google_tags_tag_binding" "binding" {
  for_each  = var.tag_bindings
  parent    = "//compute.googleapis.com/projects/${var.project}/global/addresses/${google_compute_global_address.this.name}"
  tag_value = each.value
}