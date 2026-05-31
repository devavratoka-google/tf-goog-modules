output "ncc_hub_id" {
  description = "The ID of the NCC Hub."
  value       = google_network_connectivity_hub.this.id
}

output "ncc_hub_name" {
  description = "The name of the NCC Hub."
  value       = google_network_connectivity_hub.this.name
}

output "ncc_hub_unique_id" {
  description = "The unique ID of the NCC Hub."
  value       = google_network_connectivity_hub.this.unique_id
}

