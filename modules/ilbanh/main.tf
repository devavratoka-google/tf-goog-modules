# ------------------------------------------------------------------------------
# VM RESOURCES (IPs, Template, Instances)
# ------------------------------------------------------------------------------

resource "google_compute_address" "this" {
  for_each     = var.vms
  name         = "${var.name}-${each.key}-ip"
  project      = var.project_id
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork_id
  address      = each.value.address
}

resource "google_compute_region_instance_template" "this" {
  name         = "${var.name}-template"
  project      = var.project_id
  region       = var.region
  machine_type = var.machine_type
  tags         = var.vm_tags

  metadata = {
    enable-oslogin = "true"
  }

  # Using the file you mentioned is in the child module folder
  metadata_startup_script = file("${path.module}/cloud-init-linuxnva.yaml")

  resource_manager_tags = var.resource_manager_tags

  disk {
    auto_delete  = true
    boot         = true
    device_name  = "disk01"
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    mode         = "READ_WRITE"
    source_image = var.source_image
    type         = "PERSISTENT"
  }

  network_interface {
    network            = var.network_id
    subnetwork         = var.subnetwork_id
    subnetwork_project = var.project_id
    stack_type         = "IPV4_ONLY"
  }

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }

  can_ip_forward = var.can_ip_forward
}

resource "google_compute_instance_from_template" "this" {
  for_each = var.vms
  name     = "${var.name}-${each.key}"
  project  = var.project_id
  zone     = var.zone
  tags     = var.vm_tags

  network_interface {
    subnetwork = var.subnetwork_id
    network_ip = google_compute_address.this[each.key].address
  }

  desired_status           = var.desired_status
  source_instance_template = google_compute_region_instance_template.this.self_link
}

# ------------------------------------------------------------------------------
# LOAD BALANCER RESOURCES
# ------------------------------------------------------------------------------

resource "google_compute_region_health_check" "this" {
  name    = "${var.name}-hc"
  region  = var.region
  project = var.project_id

  http_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_instance_group" "this" {
  name        = "${var.name}-ig"
  description = "Instance group for ${var.name}"
  project     = var.project_id
  zone        = var.zone
  # Dynamically pull the self_links of the VMs we just created
  instances = [for vm in google_compute_instance_from_template.this : vm.self_link]
}

resource "google_compute_region_backend_service" "this" {
  name                  = "${var.name}-backend"
  region                = var.region
  project               = var.project_id
  health_checks         = [google_compute_region_health_check.this.id]
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"

  backend {
    group          = google_compute_instance_group.this.id
    balancing_mode = "CONNECTION"
  }
}

resource "google_compute_forwarding_rule" "this" {
  name                  = var.name
  region                = var.region
  project               = var.project_id
  backend_service       = google_compute_region_backend_service.this.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  all_ports             = true
  allow_global_access   = true
  network               = var.network_id
  subnetwork            = var.subnetwork_id
}