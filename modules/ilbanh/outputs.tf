output "instances" {
  description = "The created VM instances for the NVA clusters."
  value       = google_compute_instance_from_template.this
}

output "forwarding_rule_ip" {
  description = "The IP address of the internal load balancer forwarding rule."
  value       = google_compute_forwarding_rule.this.ip_address
}

output "forwarding_rule_id" {
  description = "The ID of the internal load balancer forwarding rule."
  value       = google_compute_forwarding_rule.this.id
}

