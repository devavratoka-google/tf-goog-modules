output "cluster_name" {
  description = "Name of the planned GKE cluster."
  value       = module.gkeautopilot.cluster_name
}

output "cluster_id" {
  description = "Full ID of the planned GKE cluster."
  value       = module.gkeautopilot.cluster_id
}

output "location" {
  description = "Region or zone where the cluster is planned."
  value       = module.gkeautopilot.location
}

output "endpoint_dns" {
  description = "DNS endpoint for the control plane."
  value       = module.gkeautopilot.endpoint_dns
}

output "master_version" {
  description = "Current GKE control plane version after apply."
  value       = module.gkeautopilot.master_version
}

output "node_locations" {
  description = "Zones used by the Autopilot nodes after apply."
  value       = module.gkeautopilot.node_locations
}
