data "google_project" "proj-id" {
  project_id = var.env_project_id
}

locals {
  project_id            = "<proj-id>"
  service_account_email = "${data.google_project.proj-id.number}-compute@developer.gserviceaccount.com"
}

module "nva_ilb_clusters" {
  source   = "./modules/ilbanh"
  for_each = var.nva_clusters

  project_id            = local.project_id
  name                  = each.value.name
  region                = each.value.region
  zone                  = each.value.zone
  network_id            = each.value.network_id
  subnetwork_id         = each.value.subnetwork_id
  vms                   = each.value.vms
  service_account_email = local.service_account_email
  resource_manager_tags = each.value.resource_manager_tags

  vm_tags = ["nva"]
}