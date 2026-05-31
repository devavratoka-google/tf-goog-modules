output "router_name" {
  value = google_compute_router.this.name
}

output "router_link" {
  value = google_compute_router.this.self_link
}

output "router_project" {
  value = google_compute_router.this.project
}

output "router_region" {
  value = google_compute_router.this.region
}

output "router_id" {
  value       = google_compute_router.this.id
  description = "The ID of the router."
}