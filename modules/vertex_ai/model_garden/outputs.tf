output "endpoint_id" {
  description = "The resource ID of the Vertex AI Endpoint."
  value       = google_vertex_ai_endpoint.this.id
}

output "endpoint_name" {
  description = "The resource name (ID) of the Vertex AI Endpoint."
  value       = google_vertex_ai_endpoint.this.name
}

output "endpoint_display_name" {
  description = "The display name of the Vertex AI Endpoint."
  value       = google_vertex_ai_endpoint.this.display_name
}
