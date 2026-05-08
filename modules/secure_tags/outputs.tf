
output "tagvalue" {
  value = { for k, v in google_tags_tag_value.this : k => v.id }
}
output "tagkey" {
  value = google_tags_tag_key.this.id
}