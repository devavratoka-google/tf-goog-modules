resource "google_compute_instance_group" "this" {
  name        = var.name
  zone        = var.zone
  description = var.description
  network     = var.network

  # Prevents schema errors if the list is completely empty
  instances = length(var.instances) > 0 ? var.instances : null

  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = named_port.value.name
      port = named_port.value.port
    }
  }
}