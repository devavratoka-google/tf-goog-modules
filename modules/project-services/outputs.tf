output "enabled_services" {
  description = "Set of enabled service API identifiers."
  value       = keys(google_project_service.this)
}
