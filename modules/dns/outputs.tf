output "managed_zone_name" {
  description = "The name of the managed zone"
  value       = google_dns_managed_zone.this.name
}

output "managed_zone_id" {
  description = "The ID of the managed zone"
  value       = google_dns_managed_zone.this.id
}
