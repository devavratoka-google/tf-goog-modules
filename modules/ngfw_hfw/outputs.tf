output "hfw_id" {
  value = google_compute_firewall_policy.this.id
}

output "hfw_policy_id" {
  value = google_compute_firewall_policy.this.firewall_policy_id
}

output "hfw_selflink_id" {
  value = google_compute_firewall_policy.this.self_link_with_id
}
