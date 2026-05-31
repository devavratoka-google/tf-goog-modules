output "subnets_self_link" {
  value       = google_compute_subnetwork.this.self_link
  description = "The self link of subnetworks"
}

output "subnets_name" {
  value       = google_compute_subnetwork.this.name
  description = "The name of subnetworks"
}

output "subnets_project" {
  value = google_compute_subnetwork.this.project
}

output "subnets_region" {
  value = google_compute_subnetwork.this.region
}

output "subnets_id" {
  value       = google_compute_subnetwork.this.id
  description = "The ID of subnetworks"
}