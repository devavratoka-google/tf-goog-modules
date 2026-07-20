# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../../label-governance"
  labels = coalesce(var.labels, {})
}

resource "google_network_services_lb_traffic_extension" "this" {
  name                  = var.name
  description           = var.description
  location              = var.location
  project               = var.project
  load_balancing_scheme = var.load_balancing_scheme
  forwarding_rules      = var.forwarding_rules
  labels                = module.label_governance.validated_labels

  dynamic "extension_chains" {
    for_each = var.extension_chains
    content {
      name = extension_chains.value.name

      match_condition {
        cel_expression = extension_chains.value.match_condition.cel_expression
      }

      dynamic "extensions" {
        for_each = extension_chains.value.extensions
        content {
          name             = extensions.value.name
          authority        = extensions.value.authority
          service          = extensions.value.service
          timeout          = extensions.value.timeout
          fail_open        = extensions.value.fail_open
          forward_headers  = extensions.value.forward_headers
          supported_events = extensions.value.supported_events
          metadata         = extensions.value.metadata
        }
      }
    }
  }
}

resource "google_tags_location_tag_binding" "binding" {
  for_each  = var.tag_bindings
  parent    = "//networkservices.googleapis.com/projects/${google_network_services_lb_traffic_extension.this.project}/locations/${var.location}/lbTrafficExtensions/${google_network_services_lb_traffic_extension.this.name}"
  tag_value = each.value
  location  = var.location
}

