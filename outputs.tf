output "vpc_self_link" {
  value = { for k, v in module.networks : k => v.network_self_link }
}

output "vpc_name" {
  value = { for k, v in module.networks : k => v.network_name }
}

# output "vpc_project" {
#   value = { for k, v in module.networks : k => v.network_project }
# }

output "subnets_self_link" {
  value = { for k, v in module.subnetworks : k => v.subnets_self_link }
}

output "subnets_name" {
  value = { for k, v in module.subnetworks : k => v.subnets_name }
}

output "tag_values" {
  value       = { for k, v in module.secure_tags : k => v.tagvalue }
  description = "Tag Values"
}

output "local_peering_state" {
  value = { for k, v in module.vpc_peering : k => v.local_peering_state }
}

output "cloud_run_v2_service_uri" {
  value       = { for k, v in module.cloud_run_v2 : k => v.service_uri }
  description = "Cloud Run v2 service URIs"
}

output "cloud_run_v2_id" {
  value       = { for k, v in module.cloud_run_v2 : k => v.id }
  description = "Cloud Run v2 fully qualified resource IDs"
}
