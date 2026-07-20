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

output "vertex_ai_endpoint_id" {
  value       = { for k, v in module.vertex_ai_model_garden : k => v.endpoint_id }
  description = "Vertex AI Endpoint resource IDs via Model Garden submodule"
}

output "sql_tenant_project_id" {
  value       = { for k, v in module.cloud_sql_postgresql : k => v.instance_tenant_project_id }
  description = "The tenant project ID of the Cloud SQL PostgreSQL instances."
}

output "network_attachments_self_link" {
  value       = { for k, v in module.network_attachments : k => v.self_link }
  description = "The URIs of the created network attachments."
}

output "pubsub_topic_ids" {
  description = "IDs of the created Pub/Sub topics."
  value       = { for k, v in module.pubsub_topics : k => v.topic_id }
}

output "pubsub_subscription_ids" {
  description = "A map of topic keys to maps of subscription keys to subscription resource IDs."
  value       = { for k, v in module.pubsub_topics : k => v.subscription_ids }
}

output "service_directory_namespace_ids" {
  description = "A map of Service Directory namespace IDs created via root orchestration."
  value       = { for k, v in module.service_directories : k => v.namespace_id }
}

output "service_directory_service_ids" {
  description = "A map of created Service Directory service resource IDs per namespace key."
  value       = { for k, v in module.service_directories : k => v.service_ids }
}
