output "cluster_name" {
  description = "Cluster name."
  value       = google_container_cluster.main.name
}

output "cluster_id" {
  description = "Cluster ID."
  value       = google_container_cluster.main.id
}

output "location" {
  description = "Cluster location."
  value       = google_container_cluster.main.location
}

output "endpoint" {
  description = "Control plane endpoint."
  value       = try(google_container_cluster.main.private_cluster_config[0].private_endpoint, null)
  sensitive   = true
}

output "endpoint_dns" {
  description = "Control plane DNS endpoint."
  value       = try(google_container_cluster.main.control_plane_endpoints_config[0].dns_endpoint_config[0].endpoint, null)
}

output "ca_certificate" {
  description = "Cluster CA certificate in base64."
  value       = try(google_container_cluster.main.master_auth[0].cluster_ca_certificate, null)
  sensitive   = true
}

output "master_version" {
  description = "Current control plane version."
  value       = google_container_cluster.main.master_version
}

output "node_locations" {
  description = "Zones used by the nodes."
  value       = google_container_cluster.main.node_locations
}
