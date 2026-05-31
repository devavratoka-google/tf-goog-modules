output "global_address_name" {
  description = "The name of the reserved global IP address."
  value       = google_compute_global_address.this.name
}

output "address" {
  description = "The reserved global IP address."
  value       = google_compute_global_address.this.address
}

output "id" {
  description = "The ID of the reserved global IP address."
  value       = google_compute_global_address.this.id
}

output "self_link" {
  description = "The URI of the reserved global IP address."
  value       = google_compute_global_address.this.self_link
}

  