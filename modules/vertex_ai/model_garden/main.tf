# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../../label-governance"
  labels = coalesce(var.labels, {})
}

resource "google_vertex_ai_endpoint" "this" {
  name         = var.endpoint_name
  display_name = var.endpoint_display_name
  description  = var.endpoint_description
  location     = var.region
  project      = var.project_id
  labels       = module.label_governance.validated_labels
  network      = var.network

  dynamic "encryption_spec" {
    for_each = var.kms_key_name != null ? [1] : []
    content {
      kms_key_name = var.kms_key_name
    }
  }
}

resource "google_tags_location_tag_binding" "binding" {
  for_each  = var.tag_bindings
  parent    = "//aiplatform.googleapis.com/projects/${var.project_id}/locations/${var.region}/endpoints/${google_vertex_ai_endpoint.this.name}"
  tag_value = each.value
  location  = var.region
}

