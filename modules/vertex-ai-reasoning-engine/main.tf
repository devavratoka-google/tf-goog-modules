resource "google_vertex_ai_reasoning_engine" "this" {
  provider     = google-beta
  project      = var.project_id
  region       = var.region
  display_name = var.display_name
  description  = var.description

  spec {
    package_spec {
      python_version           = var.spec.package_spec.python_version
      pickle_object_gcs_uri    = try(var.spec.package_spec.pickle_object_gcs_uri, null)
      dependency_files_gcs_uri = try(var.spec.package_spec.dependency_files_gcs_uri, null)
      requirements_gcs_uri     = try(var.spec.package_spec.requirements_gcs_uri, null)
    }

    class_methods = try(jsonencode(var.spec.class_methods), null)
  }
}
