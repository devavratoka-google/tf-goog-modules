output "instances" {
  description = "The created VM instances for the NVA clusters."
  value       = google_compute_instance_from_template.this
}
