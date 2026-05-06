output "interconnect_attachment_id" {
  value = google_compute_interconnect_attachment.this
}

output "interconnect_attachment_cloudrouter_ip" {
  value = google_compute_interconnect_attachment.this.cloud_router_ip_address
}

output "interconnect_attachment_customerrouter_ip" {
  value = google_compute_interconnect_attachment.this.customer_router_ip_address
}

output "flow_logs_id" {
  value = google_network_management_vpc_flow_logs_config.this.id
}