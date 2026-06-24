resource "google_project_iam_member" "this" {
  for_each = toset(var.members)

  project = var.project_id
  role    = var.role
  member  = each.value

  dynamic "condition" {
    for_each = var.condition != null ? [var.condition] : []
    content {
      title       = condition.value.title
      description = try(condition.value.description, null)
      expression  = condition.value.expression
    }
  }
}
