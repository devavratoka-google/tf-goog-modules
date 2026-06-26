# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../label-governance"
  labels = coalesce(merge(var.resource_labels, var.labels), {})
}

locals {
  required_services = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "run.googleapis.com"
  ])

  workload_pool = coalesce(var.workload_pool, "${var.project_id}.svc.id.goog")

  # Not needed for DNS-only control plane access.
  # This block is only sent when IP-based endpoint access needs CIDR allowlists.
  master_authorized_networks_config = length(var.master_authorized_networks) > 0 || var.gcp_public_cidrs_access_enabled || var.private_endpoint_enforcement_enabled != null ? {
    cidr_blocks = var.master_authorized_networks

    gcp_public_cidrs_access_enabled      = var.gcp_public_cidrs_access_enabled
    private_endpoint_enforcement_enabled = var.private_endpoint_enforcement_enabled
  } : null
}

resource "google_project_service" "services" {
  for_each = local.required_services

  project = var.project_id
  service = each.value

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_container_cluster" "main" {
  provider = google-beta

  project             = var.project_id
  name                = var.name
  description         = var.description
  resource_labels     = module.label_governance.validated_labels
  location            = var.location
  node_locations      = var.node_locations
  network             = var.network
  subnetwork          = var.subnetwork
  deletion_protection = var.env == "prod" ? true : false

  datapath_provider        = var.datapath_provider
  enable_l4_ilb_subsetting = var.enable_l4_ilb_subsetting
  enable_autopilot         = true
  networking_mode          = "VPC_NATIVE"

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [var.release_channel] : []
    content {
      channel = release_channel.value.channel
    }
  }

  dynamic "gateway_api_config" {
    for_each = var.gateway_api_config != null ? [var.gateway_api_config] : []
    content {
      channel = gateway_api_config.value.channel
    }
  }

  dynamic "cost_management_config" {
    for_each = var.cost_management_config != null ? [var.cost_management_config] : []
    content {
      enabled = cost_management_config.value.enabled
    }
  }

  dynamic "confidential_nodes" {
    for_each = var.confidential_nodes != null ? [var.confidential_nodes] : []
    content {
      enabled = confidential_nodes.value.enabled
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      enable_components = logging_config.value.enable_components
    }
  }

  dynamic "monitoring_config" {
    for_each = var.monitoring_config != null ? [var.monitoring_config] : []
    content {
      enable_components = monitoring_config.value.enable_components
    }
  }

  dynamic "vertical_pod_autoscaling" {
    for_each = var.vertical_pod_autoscaling != null ? [var.vertical_pod_autoscaling] : []
    content {
      enabled = vertical_pod_autoscaling.value.enabled
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config != null ? [local.master_authorized_networks_config] : []
    content {
      gcp_public_cidrs_access_enabled      = master_authorized_networks_config.value.gcp_public_cidrs_access_enabled
      private_endpoint_enforcement_enabled = master_authorized_networks_config.value.private_endpoint_enforcement_enabled

      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          display_name = cidr_blocks.value.display_name
          cidr_block   = cidr_blocks.value.cidr_block
        }
      }
    }
  }

  dynamic "node_pool_auto_config" {
    for_each = var.node_pool_auto_config != null ? [var.node_pool_auto_config] : []
    content {
      resource_manager_tags = node_pool_auto_config.value.resource_manager_tags

      dynamic "node_kubelet_config" {
        for_each = node_pool_auto_config.value.node_kubelet_config != null ? [node_pool_auto_config.value.node_kubelet_config] : []
        content {
          insecure_kubelet_readonly_port_enabled = upper(tostring(node_kubelet_config.value.insecure_kubelet_readonly_port_enabled))
        }
      }

      dynamic "network_tags" {
        for_each = node_pool_auto_config.value.network_tags != null ? [node_pool_auto_config.value.network_tags] : []
        content {
          tags = network_tags.value.tags
        }
      }

      dynamic "linux_node_config" {
        for_each = node_pool_auto_config.value.linux_node_config != null ? [node_pool_auto_config.value.linux_node_config] : []
        content {
          cgroup_mode = linux_node_config.value.cgroup_mode
        }
      }
    }
  }

  dynamic "service_external_ips_config" {
    for_each = var.service_external_ips_config != null ? [var.service_external_ips_config] : []
    content {
      enabled = service_external_ips_config.value.enabled
    }
  }

  dynamic "addons_config" {
    for_each = var.addons_config != null ? [var.addons_config] : []
    content {
      dynamic "gcp_filestore_csi_driver_config" {
        for_each = addons_config.value.gcp_filestore_csi_driver_config != null ? [addons_config.value.gcp_filestore_csi_driver_config] : []
        content {
          enabled = gcp_filestore_csi_driver_config.value.enabled
        }
      }

      dynamic "gke_backup_agent_config" {
        for_each = addons_config.value.gke_backup_agent_config != null ? [addons_config.value.gke_backup_agent_config] : []
        content {
          enabled = gke_backup_agent_config.value.enabled
        }
      }

      dynamic "ray_operator_config" {
        for_each = addons_config.value.ray_operator_config != null ? [addons_config.value.ray_operator_config] : []
        content {
          enabled = ray_operator_config.value.enabled

          dynamic "ray_cluster_logging_config" {
            for_each = ray_operator_config.value.ray_cluster_logging_config != null ? [ray_operator_config.value.ray_cluster_logging_config] : []
            content {
              enabled = ray_cluster_logging_config.value.enabled
            }
          }

          dynamic "ray_cluster_monitoring_config" {
            for_each = ray_operator_config.value.ray_cluster_monitoring_config != null ? [ray_operator_config.value.ray_cluster_monitoring_config] : []
            content {
              enabled = ray_cluster_monitoring_config.value.enabled
            }
          }
        }
      }
    }
  }

  dynamic "security_posture_config" {
    for_each = var.security_posture_config != null ? [var.security_posture_config] : []
    content {
      mode               = security_posture_config.value.mode
      vulnerability_mode = security_posture_config.value.vulnerability_mode
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy != null ? [var.ip_allocation_policy] : []
    content {
      cluster_secondary_range_name  = ip_allocation_policy.value.cluster_secondary_range_name
      services_secondary_range_name = ip_allocation_policy.value.services_secondary_range_name
      cluster_ipv4_cidr_block       = ip_allocation_policy.value.cluster_ipv4_cidr_block
      services_ipv4_cidr_block      = ip_allocation_policy.value.services_ipv4_cidr_block
      stack_type                    = ip_allocation_policy.value.stack_type

      dynamic "additional_pod_ranges_config" {
        for_each = ip_allocation_policy.value.additional_pod_ranges_config != null ? [ip_allocation_policy.value.additional_pod_ranges_config] : []
        content {
          pod_range_names = additional_pod_ranges_config.value.pod_range_names
        }
      }
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? [var.maintenance_policy] : []
    content {
      dynamic "daily_maintenance_window" {
        for_each = maintenance_policy.value.daily_maintenance_window != null ? [maintenance_policy.value.daily_maintenance_window] : []
        content {
          start_time = daily_maintenance_window.value.start_time
        }
      }

      dynamic "recurring_window" {
        for_each = maintenance_policy.value.recurring_window != null ? [maintenance_policy.value.recurring_window] : []
        content {
          start_time = recurring_window.value.start_time
          end_time   = recurring_window.value.end_time
          recurrence = recurring_window.value.recurrence
        }
      }

      dynamic "maintenance_exclusion" {
        for_each = maintenance_policy.value.maintenance_exclusion != null ? maintenance_policy.value.maintenance_exclusion : []
        content {
          exclusion_name = maintenance_exclusion.value.exclusion_name
          start_time     = maintenance_exclusion.value.start_time
          end_time       = maintenance_exclusion.value.end_time

          dynamic "exclusion_options" {
            for_each = maintenance_exclusion.value.exclusion_options != null ? [maintenance_exclusion.value.exclusion_options] : []
            content {
              scope = exclusion_options.value.scope
            }
          }
        }
      }
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config != null ? [var.private_cluster_config] : []
    content {
      enable_private_nodes        = private_cluster_config.value.enable_private_nodes
      enable_private_endpoint     = private_cluster_config.value.enable_private_endpoint
      master_ipv4_cidr_block      = private_cluster_config.value.master_ipv4_cidr_block
      private_endpoint_subnetwork = private_cluster_config.value.private_endpoint_subnetwork

      dynamic "master_global_access_config" {
        for_each = private_cluster_config.value.master_global_access_config != null ? [private_cluster_config.value.master_global_access_config] : []
        content {
          enabled = master_global_access_config.value.enabled
        }
      }
    }
  }

  dynamic "control_plane_endpoints_config" {
    for_each = var.control_plane_endpoints_config != null ? [var.control_plane_endpoints_config] : []
    content {
      dynamic "dns_endpoint_config" {
        for_each = control_plane_endpoints_config.value.dns_endpoint_config != null ? [control_plane_endpoints_config.value.dns_endpoint_config] : []
        content {
          allow_external_traffic = dns_endpoint_config.value.allow_external_traffic
        }
      }

      dynamic "ip_endpoints_config" {
        for_each = control_plane_endpoints_config.value.ip_endpoints_config != null ? [control_plane_endpoints_config.value.ip_endpoints_config] : []
        content {
          enabled = ip_endpoints_config.value.enabled
        }
      }
    }
  }

  dynamic "database_encryption" {
    for_each = var.database_encryption != null ? [var.database_encryption] : []
    content {
      state    = database_encryption.value.state
      key_name = database_encryption.value.key_name
    }
  }

  workload_identity_config {
    workload_pool = local.workload_pool
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  depends_on = [
    google_project_service.services,
  ]
}
