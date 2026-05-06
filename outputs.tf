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