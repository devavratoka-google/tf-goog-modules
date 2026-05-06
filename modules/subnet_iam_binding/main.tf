resource "google_compute_subnetwork_iam_binding" "this" {
  project    = var.project
  region     = var.region
  subnetwork = var.subnetwork
  role       = var.role
  members    = var.members
}