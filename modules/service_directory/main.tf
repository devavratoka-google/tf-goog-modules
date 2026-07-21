# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../label-governance"
  labels = coalesce(var.labels, {})
}

resource "google_service_directory_namespace" "namespace" {
  namespace_id = var.namespace_id
  location     = var.location
  project      = var.project_id
  labels       = module.label_governance.validated_labels
}

resource "google_service_directory_service" "service" {
  for_each = var.services

  service_id = each.key
  namespace  = google_service_directory_namespace.namespace.id
  metadata   = try(each.value.metadata, {})
}

resource "google_service_directory_endpoint" "endpoint" {
  for_each = var.endpoints

  endpoint_id = each.key
  service     = google_service_directory_service.service[each.value.service_id].id
  address     = each.value.address
  port        = try(each.value.port, 443)
  network     = try(each.value.network, null)
  metadata    = try(each.value.metadata, {})

  lifecycle {
    ignore_changes = [network]
  }
}
