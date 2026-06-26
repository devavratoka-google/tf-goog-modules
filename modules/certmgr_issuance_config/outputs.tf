output "id_use4" {
  description = "The IDs of the Certificate Manager issuance configs in us-east4."
  value       = { for k, v in google_certificate_manager_certificate_issuance_config.this_use4 : k => v.id }
}

output "name_use4" {
  description = "The names of the Certificate Manager issuance configs in us-east4."
  value       = { for k, v in google_certificate_manager_certificate_issuance_config.this_use4 : k => v.name }
}

output "id_usw1" {
  description = "The IDs of the Certificate Manager issuance configs in us-west1."
  value       = { for k, v in google_certificate_manager_certificate_issuance_config.this_usw1 : k => v.id }
}

output "name_usw1" {
  description = "The names of the Certificate Manager issuance configs in us-west1."
  value       = { for k, v in google_certificate_manager_certificate_issuance_config.this_usw1 : k => v.name }
}

output "all_project_ids" {
  description = "The list of all active project IDs retrieved."
  value       = [for project in data.google_projects.all_org_projects.projects : project.project_id]
}
