output "ncc_spoke_id" {
  description = "The ID of the NCC Spoke."
  value       = google_network_connectivity_spoke.this.id
}

output "ncc_spoke_name" {
  description = "The name of the NCC Spoke."
  value       = google_network_connectivity_spoke.this.name
}

output "ncc_spoke_unique_id" {
  description = "The unique ID of the NCC Spoke."
  value       = google_network_connectivity_spoke.this.unique_id
}

