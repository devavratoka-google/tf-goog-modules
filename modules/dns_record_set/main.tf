resource "google_dns_record_set" "this" {
  project      = var.project
  managed_zone = var.managed_zone
  name         = var.name
  type         = var.type
  ttl          = var.ttl
  rrdatas      = var.rrdatas
}
