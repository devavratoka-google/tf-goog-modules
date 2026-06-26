data "google_projects" "all_org_projects" {
  # This retrieves all ACTIVE projects visible to your identity
  filter = "lifecycleState:ACTIVE"
}

###### Region 1 ######

resource "google_certificate_manager_certificate_issuance_config" "this_use4" {
  for_each                   = { for p in data.google_projects.all_org_projects.projects : p.project_id => p }
  name                       = "${each.value.project_id}-issuance-config"
  description                = "${each.value.project_id}-issuance-config"
  rotation_window_percentage = 66
  key_algorithm              = "RSA_2048"
  lifetime                   = "2592000s"

  certificate_authority_config {
    certificate_authority_service_config {
      ca_pool = "projects/<pki-proj-id>/locations/us-east4/caPools/<ca-pool-id>"
    }
  }

  labels   = each.value.labels
  location = "us-east4"
  project  = each.value.project_id
}

resource "google_privateca_ca_pool_iam_member" "certrequester_use4" {
  for_each = { for p in data.google_projects.all_org_projects.projects : p.project_id => p }
  ca_pool  = "projects/<pki-proj-id>/locations/us-east4/caPools/<ca-pool-id>"
  project  = "pki-proj"
  role     = "roles/privateca.certificateRequester"
  member   = "service-${each.value.number}@gcp-sa-certificatemanager.iam.gserviceaccount.com"
}

###### Region 2 ######

resource "google_certificate_manager_certificate_issuance_config" "this_usw1" {
  for_each                   = { for p in data.google_projects.all_org_projects.projects : p.project_id => p }
  name                       = "${each.value.project_id}-issuance-config"
  description                = "${each.value.project_id}-issuance-config"
  rotation_window_percentage = 66
  key_algorithm              = "RSA_2048"
  lifetime                   = "2592000s"

  certificate_authority_config {
    certificate_authority_service_config {
      ca_pool = "projects/<pki-proj-id>/locations/us-east4/caPools/<ca-pool-id>"
    }
  }

  labels   = each.value.labels
  location = "us-west1"
  project  = each.value.project_id
}

// This is commented for now, until we have the ca pool configured for this region

# resource "google_privateca_ca_pool_iam_member" "certrequester_usw1" {
#   for_each = { for p in data.google_projects.all_org_projects.projects : p.project_id => p }
#   ca_pool  = "projects/sjc-pr-ssvcs-pki-01/locations/us-west1/caPools/<ca-pool-id>"
#   project  = "pki-proj"
#   role     = "roles/privateca.certificateRequester"
#   member   = "service-${each.value.number}@gcp-sa-certificatemanager.iam.gserviceaccount.com"
# }
