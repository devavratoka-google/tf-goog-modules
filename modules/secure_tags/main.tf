resource "google_tags_tag_key" "this" {
  parent       = var.parent
  short_name   = var.short_name
  description  = var.description
  purpose      = "GCE_FIREWALL"
  purpose_data = var.purpose_data
}

resource "google_tags_tag_key_iam_binding" "viewer" {
  count   = length(var.iam_viewer_members) > 0 ? 1 : 0
  tag_key = google_tags_tag_key.this.name
  role    = "roles/resourcemanager.tagViewer"
  members = var.iam_viewer_members
}

resource "google_tags_tag_key_iam_binding" "user" {
  count   = length(var.iam_user_members) > 0 ? 1 : 0
  tag_key = google_tags_tag_key.this.name
  role    = "roles/resourcemanager.tagUser"
  members = var.iam_user_members
}

// Create multiple Tag Values

resource "google_tags_tag_value" "this" {
  for_each    = var.tag_values
  parent      = "tagKeys/${google_tags_tag_key.this.name}"
  short_name  = each.value.tagvalue_short_name
  description = each.value.tagvalue_description
}

resource "google_tags_tag_value_iam_binding" "viewer" {
  for_each  = length(var.iam_viewer_members) > 0 ? var.tag_values : {}
  tag_value = "tagValues/${google_tags_tag_value.this[each.key].name}"
  role      = "roles/resourcemanager.tagViewer"
  members   = var.iam_viewer_members
}

resource "google_tags_tag_value_iam_binding" "user" {
  for_each  = length(var.iam_user_members) > 0 ? var.tag_values : {}
  tag_value = "tagValues/${google_tags_tag_value.this[each.key].name}"
  role      = "roles/resourcemanager.tagUser"
  members   = var.iam_user_members
}