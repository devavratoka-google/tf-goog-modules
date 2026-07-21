output "id" {
  description = "The ID of the region target TCP proxy."
  value       = google_compute_region_target_tcp_proxy.this.id
}

output "self_link" {
  description = "The URI of the created resource."
  value       = google_compute_region_target_tcp_proxy.this.self_link
}
