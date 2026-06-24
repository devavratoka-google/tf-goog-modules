output "id" {
  description = "The ID of the target HTTP proxy."
  value       = try(google_compute_region_target_http_proxy.http[0].id, google_compute_region_target_https_proxy.https[0].id, null)
}

output "url_map_id" {
  description = "The ID of the URL map."
  value       = google_compute_region_url_map.this.id
}

output "ssl_certificate_id" {
  description = "Self-link of the managed SSL certificate, if created."
  value       = length(google_compute_region_ssl_certificate.managed) > 0 ? google_compute_region_ssl_certificate.managed[0].id : null
}
