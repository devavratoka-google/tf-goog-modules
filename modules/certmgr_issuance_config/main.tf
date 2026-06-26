resource "google_certificate_manager_certificate_issuance_config" "this" {
  name                       = var.name
  description                = var.description
  rotation_window_percentage = var.rotation_window_percentage
  key_algorithm              = var.key_algorithm
  lifetime                   = var.lifetime

  certificate_authority_config {
    certificate_authority_service_config {
      ca_pool = var.ca_pool
    }
  }

  labels          = var.labels
  location        = var.location
  project         = var.project
}

resource "google_privateca_ca_pool_iam_member" "member" {
  for_each = var.members
  ca_pool  = google_certificate_manager_certificate_issuance_config.this.certificate_authority_config[0].certificate_authority_service_config[0].ca_pool
  role     = "roles/privateca.certificateManager"
  member   = each.value
}