output "network" {
  value       = google_compute_network.this
  description = "The VPC resource being created"
}

output "network_name" {
  value       = google_compute_network.this.name
  description = "The name of the VPC being created"
}

output "network_id" {
  value       = google_compute_network.this.id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.this.self_link
  description = "The URI of the VPC being created"
}

output "network_project" {
  value       = google_compute_network.this.project
  description = "The project of the VPC being created"
}