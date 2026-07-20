output "namespace_id" {
  description = "The fully qualified resource ID of the created namespace."
  value       = google_service_directory_namespace.namespace.id
}

output "namespace_name" {
  description = "The name of the created namespace."
  value       = google_service_directory_namespace.namespace.name
}

output "service_ids" {
  description = "A map of created service IDs."
  value       = { for k, v in google_service_directory_service.service : k => v.id }
}

output "endpoint_ids" {
  description = "A map of created endpoint IDs."
  value       = { for k, v in google_service_directory_endpoint.endpoint : k => v.id }
}
