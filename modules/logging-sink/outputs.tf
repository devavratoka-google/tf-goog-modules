output "writer_identity" {
  description = "The service account that writes to the destination. Grant this identity IAM access on the destination resource."
  value       = google_logging_project_sink.this.writer_identity
}

output "name" {
  value = google_logging_project_sink.this.name
}

output "id" {
  value = google_logging_project_sink.this.id
}
