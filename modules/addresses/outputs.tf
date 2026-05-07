output "address" {
  description = "The IP address reserved"
  value       = google_compute_address.this.address
}

output "name" {
  description = "The name of the address"
  value       = google_compute_address.this.name
}

output "self_link" {
  description = "The URI of the created resource"
  value       = google_compute_address.this.self_link
}
