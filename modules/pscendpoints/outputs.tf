output "address" {
  value       = google_compute_address.this.address
  description = "The IP address reserved."
}

output "address_name" {
  value       = google_compute_address.this.name
  description = "The name of the address."
}

output "address_self_link" {
  value       = google_compute_address.this.self_link
  description = "The self-link of the address."
}

output "regional_endpoint_name" {
  value       = length(google_network_connectivity_regional_endpoint.this) > 0 ? google_network_connectivity_regional_endpoint.this[0].name : null
  description = "The name of the regional endpoint."
}

output "regional_endpoint_id" {
  value       = length(google_network_connectivity_regional_endpoint.this) > 0 ? google_network_connectivity_regional_endpoint.this[0].id : null
  description = "The ID of the regional endpoint."
}

output "psc_forwarding_rule" {
  value       = length(google_compute_forwarding_rule.this) > 0 ? google_compute_forwarding_rule.this[0] : null
  description = "The full forwarding rule resource for consumer PSC."
}

output "target_google_api" {
  value       = var.target_google_api
  description = "The target Google API."
}

output "consumer_forwarding_rule_name" {
  value       = length(google_compute_forwarding_rule.this) > 0 ? google_compute_forwarding_rule.this[0].name : null
  description = "The name of the consumer forwarding rule."
}

output "consumer_forwarding_rule_self_link" {
  value       = length(google_compute_forwarding_rule.this) > 0 ? google_compute_forwarding_rule.this[0].self_link : null
  description = "The self-link of the consumer forwarding rule."
}

output "consumer_psc_connection_id" {
  value       = length(google_compute_forwarding_rule.this) > 0 ? google_compute_forwarding_rule.this[0].psc_connection_id : null
  description = "The PSC connection ID of the consumer forwarding rule."
}

output "consumer_psc_connection_status" {
  value       = length(google_compute_forwarding_rule.this) > 0 ? google_compute_forwarding_rule.this[0].psc_connection_status : null
  description = "The PSC connection status of the consumer forwarding rule."
}

output "service_attachment_name" {
  value       = length(google_compute_service_attachment.this) > 0 ? google_compute_service_attachment.this[0].name : null
  description = "The name of the service attachment."
}

output "service_attachment_self_link" {
  value       = length(google_compute_service_attachment.this) > 0 ? google_compute_service_attachment.this[0].self_link : null
  description = "The self-link of the service attachment."
}
