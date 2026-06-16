output "cluster_name" {
  description = "Cluster name."
  value       = module.gke_autopilot.cluster_name
}

output "cluster_id" {
  description = "Cluster ID."
  value       = module.gke_autopilot.cluster_id
}

output "location" {
  description = "Cluster location."
  value       = module.gke_autopilot.location
}

output "endpoint" {
  description = "Control plane endpoint."
  value       = module.gke_autopilot.endpoint
  sensitive   = true
}

output "endpoint_dns" {
  description = "Control plane DNS endpoint."
  value       = module.gke_autopilot.endpoint_dns
}

output "ca_certificate" {
  description = "Cluster CA certificate in base64."
  value       = module.gke_autopilot.ca_certificate
  sensitive   = true
}

output "master_version" {
  description = "Current control plane version."
  value       = module.gke_autopilot.master_version
}

output "node_locations" {
  description = "Zones used by the nodes."
  value       = module.gke_autopilot.node_locations
}
