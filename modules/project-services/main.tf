resource "google_project_service" "this" {
  for_each = toset(var.services)

  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = var.disable_on_destroy
  disable_dependent_services = var.disable_dependent_services
}

resource "google_project_service_identity" "this" {
  for_each = var.service_identities

  provider = google-beta
  project  = var.project_id
  service  = each.key

  depends_on = [google_project_service.this]
}
