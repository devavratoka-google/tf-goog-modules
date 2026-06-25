resource "google_certificate_manager_certificate_issuance_config" "this" {
  name                       = var.name
  description                = var.description
  rotation_window_percentage = var.rotation_window_percentage
  key_algorithm              = var.key_algorithm
  lifetime                   = var.lifetime

  dynamic "certificate_authority_config" {
    for_each = var.certificate_authority_config == null ? [] : [var.certificate_authority_config]
    content {
      dynamic "certificate_authority_service_config" {
        for_each = certificate_authority_config.value.certificate_authority_service_config == null ? [] : [certificate_authority_config.value.certificate_authority_service_config]
        content {
          ca_pool = certificate_authority_service_config.value.ca_pool
        }
      }
    }
  }

  labels          = var.labels
  location        = var.location
  project         = var.project
}
