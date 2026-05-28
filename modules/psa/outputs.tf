output "id" {
  description = "The ID of the service networking connection."
  value       = google_service_networking_connection.this.id
}

output "peering" {
  description = "The name of the VPC peering connection created."
  value       = google_service_networking_connection.this.peering
}
