resource "google_vertex_ai_reasoning_engine" "this" {
  provider     = google-beta
  project      = var.project_id
  region       = var.region
  display_name = var.display_name
  description  = var.description

  # spec is optional: omit the block entirely for a parent-only engine
  # (no deployed agent code). When var.spec is set, the engine hosts a
  # pickled agent object described by package_spec.
  dynamic "spec" {
    for_each = var.spec != null ? [var.spec] : []
    content {
      package_spec {
        python_version           = spec.value.package_spec.python_version
        pickle_object_gcs_uri    = try(spec.value.package_spec.pickle_object_gcs_uri, null)
        dependency_files_gcs_uri = try(spec.value.package_spec.dependency_files_gcs_uri, null)
        requirements_gcs_uri     = try(spec.value.package_spec.requirements_gcs_uri, null)
      }

      class_methods = try(jsonencode(spec.value.class_methods), null)
    }
  }
}
