output "id" {
  description = "The ID of the created network attachment."
  value       = google_compute_network_attachment.this.id
}

output "self_link" {
  description = "The URI (self_link) of the created network attachment. Use this as the network_attachment_uri for Cloud SQL outbound PSC."
  value       = google_compute_network_attachment.this.self_link
}

output "name" {
  description = "The name of the created network attachment."
  value       = google_compute_network_attachment.this.name
}
