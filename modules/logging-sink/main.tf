resource "google_logging_project_sink" "this" {
  project                = var.project_id
  name                   = var.name
  destination            = var.destination
  filter                 = var.filter
  description            = var.description
  disabled               = var.disabled
  unique_writer_identity = true

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      description = try(exclusions.value.description, null)
      filter      = exclusions.value.filter
      disabled    = try(exclusions.value.disabled, false)
    }
  }
}
