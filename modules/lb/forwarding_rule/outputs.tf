output "id" {
  description = "The ID of the forwarding rule."
  value       = google_compute_forwarding_rule.this.id
}

output "self_link" {
  description = "The URI of the forwarding rule."
  value       = google_compute_forwarding_rule.this.self_link
}
