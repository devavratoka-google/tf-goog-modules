output "id" {
  description = "The ID of the created network attachment."
  value       = google_compute_network_attachment.this.id
}

output "self_link" {
  description = "The URI of the created network attachment."
  value       = google_compute_network_attachment.this.self_link
}

output "name" {
  description = "The name of the created network attachment."
  value       = google_compute_network_attachment.this.name
}
