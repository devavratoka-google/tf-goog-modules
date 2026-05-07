output "policy_id" {
  description = "The ID of the DNS policy"
  value       = google_dns_policy.this.id
}
