output "id" {
  description = "The ID of the Certificate Manager issuance config."
  value       = google_certificate_manager_certificate_issuance_config.this.id
}

output "name" {
  description = "The name of the Certificate Manager issuance config."
  value       = google_certificate_manager_certificate_issuance_config.this.name
}
