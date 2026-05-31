output "health_check_name" {
  description = "The name of the health check."
  value       = google_compute_region_health_check.this.name
}

output "id" {
  description = "The ID of the health check."
  value       = google_compute_region_health_check.this.id
}

output "self_link" {
  description = "The URI of the health check."
  value       = google_compute_region_health_check.this.self_link
}