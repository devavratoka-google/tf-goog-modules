output "id" {
  value       = google_dns_record_set.this.id
  description = "An identifier for the resource with format projects/{{project}}/managedZones/{{managed_zone}}/rrsets/{{name}}/{{type}}"
}

output "name" {
  value       = google_dns_record_set.this.name
  description = "The DNS name of this record set"
}
