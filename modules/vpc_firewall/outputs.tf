output "firewall_rules" {
  description = "The created firewall rule resources."
  value       = google_compute_firewall.rules
}
