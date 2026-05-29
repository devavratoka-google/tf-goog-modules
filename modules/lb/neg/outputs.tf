output "id" {
  description = "The ID of the network endpoint group."
  value       = try(google_compute_network_endpoint_group.zonal[0].id, google_compute_region_network_endpoint_group.serverless[0].id, null)
}

output "self_link" {
  description = "The URI of the network endpoint group."
  value       = try(google_compute_network_endpoint_group.zonal[0].self_link, google_compute_region_network_endpoint_group.serverless[0].self_link, null)
}
