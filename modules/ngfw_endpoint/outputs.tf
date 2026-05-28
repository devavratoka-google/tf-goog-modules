output "id" {
  description = "The ID of the created firewall endpoint."
  value       = google_network_security_firewall_endpoint.this.id
}

output "self_link" {
  description = "The URI of the created firewall endpoint."
  value       = google_network_security_firewall_endpoint.this.self_link
}

output "name" {
  description = "The name of the created firewall endpoint."
  value       = google_network_security_firewall_endpoint.this.name
}

output "associations" {
  description = "A map of firewall endpoint associations created."
  value       = { for k, v in google_network_security_firewall_endpoint_association.this : k => v.id }
}
