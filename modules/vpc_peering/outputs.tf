output "local_peering_id" {
  description = "The ID of the local VPC peering connection."
  value       = google_compute_network_peering.local_network_peering.id
}

output "local_peering_state" {
  description = "The state of the local VPC peering connection."
  value       = google_compute_network_peering.local_network_peering.state
}

output "peer_peering_id" {
  description = "The ID of the peer VPC peering connection."
  value       = google_compute_network_peering.peer_network_peering.id
}

output "peer_peering_state" {
  description = "The state of the peer VPC peering connection."
  value       = google_compute_network_peering.peer_network_peering.state
}

