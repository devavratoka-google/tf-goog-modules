output "global_address_name" {
  description = "The IP address reserved"
  value       = google_compute_global_address.this.name
}
  