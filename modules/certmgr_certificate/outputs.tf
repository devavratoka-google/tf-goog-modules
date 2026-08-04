output "id" {
  description = "The an identifier for the resource with format projects/{{project}}/locations/{{location}}/certificates/{{name}}."
  value       = google_certificate_manager_certificate.this.id
}

output "name" {
  description = "The name of the Certificate Manager certificate."
  value       = google_certificate_manager_certificate.this.name
}

output "location" {
  description = "The location of the Certificate Manager certificate."
  value       = google_certificate_manager_certificate.this.location
}

output "project" {
  description = "The project ID of the Certificate Manager certificate."
  value       = google_certificate_manager_certificate.this.project
}

output "issuance_config_id" {
  description = "The ID of the Certificate Manager Issuance Config resolved by convention."
  value       = local.issuance_config_id
}

output "issuance_config_name" {
  description = "The name of the Certificate Manager Issuance Config resolved by convention."
  value       = local.issuance_config_name
}
