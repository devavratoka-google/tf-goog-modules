output "id" {
  description = "The ID of the unmanaged instance group."
  value       = google_compute_instance_group.this.id
}

output "self_link" {
  description = "The URI of the unmanaged instance group."
  value       = google_compute_instance_group.this.self_link
}
