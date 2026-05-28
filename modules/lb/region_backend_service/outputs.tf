output "id" {
  description = "The ID of the region backend service."
  value       = google_compute_region_backend_service.this.id
}

output "self_link" {
  description = "The URI of the region backend service."
  value       = google_compute_region_backend_service.this.self_link
}
