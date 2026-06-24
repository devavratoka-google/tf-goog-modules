variable "project_id" {
  description = "GCP project ID where the cluster will be created."
  type        = string
}

variable "env" {
  description = "Environment name used for environment-sensitive safeguards."
  type        = string
  default     = "dev"
}

variable "name" {
  description = "GKE Autopilot cluster name."
  type        = string
}

variable "location" {
  description = "Cluster region or zone. Use a region for a regional cluster, for example us-central1 or southamerica-east1."
  type        = string
}

variable "network" {
  description = "Name or self link of the VPC network where the cluster will be connected."
  type        = string
}

variable "subnetwork" {
  description = "Name or self link of the subnetwork where the cluster will be connected."
  type        = string
}

variable "ip_allocation_policy" {
  description = "Cluster IP allocation policy. For VPC-native clusters, provide the pod and service secondary range names or CIDRs."
  type = object({
    cluster_secondary_range_name  = optional(string)
    services_secondary_range_name = optional(string)
    cluster_ipv4_cidr_block       = optional(string)
    services_ipv4_cidr_block      = optional(string)
    stack_type                    = optional(string)
    additional_pod_ranges_config = optional(object({
      pod_range_names = list(string)
    }))
  })
  default = null
}

variable "master_authorized_networks" {
  description = "CIDR blocks authorized to access the control plane."
  type = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "gcp_public_cidrs_access_enabled" {
  description = "Allows control plane access from Google Cloud public CIDR blocks."
  type        = bool
  default     = false
}

variable "private_endpoint_enforcement_enabled" {
  description = "Applies master authorized networks enforcement to the private endpoint."
  type        = bool
  default     = null
}

variable "private_cluster_config" {
  description = "Private cluster configuration."
  type = object({
    enable_private_nodes        = optional(bool)
    enable_private_endpoint     = optional(bool)
    master_ipv4_cidr_block      = optional(string)
    private_endpoint_subnetwork = optional(string)
    master_global_access_config = optional(object({
      enabled = optional(bool)
    }))
  })
  default = {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_global_access_config = {
      enabled = true
    }
  }
}

variable "control_plane_endpoints_config" {
  description = "Control plane endpoint configuration. Enable DNS access to let authorized users connect through the GKE DNS endpoint."
  type = object({
    dns_endpoint_config = optional(object({
      allow_external_traffic = optional(bool)
    }))
    ip_endpoints_config = optional(object({
      enabled = optional(bool)
    }))
  })
  default = null
}

variable "workload_pool" {
  description = "Workload Identity pool. If null, uses project_id.svc.id.goog."
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Prevents Terraform from destroying the cluster when true."
  type        = bool
  default     = true
}

variable "description" {
  description = "Cluster description."
  type        = string
  default     = ""
}

variable "resource_labels" {
  description = "Labels applied to the cluster."
  type        = map(string)
  default     = {}
}

variable "release_channel" {
  description = "GKE release channel."
  type = object({
    channel = optional(string)
  })
  default = {
    channel = "REGULAR"
  }
}

variable "vertical_pod_autoscaling" {
  description = "Vertical Pod Autoscaling configuration."
  type = object({
    enabled = optional(bool)
  })
  default = {
    enabled = true
  }
}

variable "logging_config" {
  description = "GKE components with logging enabled."
  type = object({
    enable_components = optional(list(string))
  })
  default = {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
}

variable "monitoring_config" {
  description = "GKE components with metrics enabled."
  type = object({
    enable_components = optional(list(string))
  })
  default = {
    enable_components = ["SYSTEM_COMPONENTS"]
  }
}

variable "addons_config" {
  description = "Add-ons supported by GKE Autopilot."
  type = object({
    gcp_filestore_csi_driver_config = optional(object({
      enabled = optional(bool)
    }))
    gke_backup_agent_config = optional(object({
      enabled = optional(bool)
    }))
    ray_operator_config = optional(object({
      enabled = optional(bool)
      ray_cluster_logging_config = optional(object({
        enabled = optional(bool)
      }))
      ray_cluster_monitoring_config = optional(object({
        enabled = optional(bool)
      }))
    }))
  })
  default = null
}

variable "confidential_nodes" {
  description = "Confidential Nodes configuration."
  type = object({
    enabled = bool
  })
  default = null
}

variable "cost_management_config" {
  description = "Cluster Cost Management configuration."
  type = object({
    enabled = optional(bool)
  })
  default = {
    enabled = true
  }
}

variable "database_encryption" {
  description = "Application-layer Secrets encryption, optionally using a KMS key."
  type = object({
    state    = optional(string)
    key_name = optional(string)
  })
  default = null
}

variable "datapath_provider" {
  description = "Datapath provider. For example, use ADVANCED_DATAPATH for Dataplane V2."
  type        = string
  default     = "ADVANCED_DATAPATH"
}

variable "enable_l4_ilb_subsetting" {
  description = "Enables L4 ILB subsetting."
  type        = bool
  default     = true
}

variable "gateway_api_config" {
  description = "Gateway API configuration."
  type = object({
    channel = string
  })
  default = null
}

variable "maintenance_policy" {
  description = "Cluster maintenance policy."
  type = object({
    daily_maintenance_window = optional(object({
      start_time = optional(string)
    }))
    recurring_window = optional(object({
      start_time = optional(string)
      end_time   = optional(string)
      recurrence = optional(string)
    }))
    maintenance_exclusion = optional(list(object({
      exclusion_name = optional(string)
      start_time     = optional(string)
      end_time       = optional(string)
      exclusion_options = optional(object({
        scope = optional(string)
      }))
    })))
  })
  default = {
    daily_maintenance_window = {
      start_time = "05:00"
    }
  }
}

variable "node_locations" {
  description = "Node zones. Optional for zonal clusters; for regional clusters this can restrict the zones used."
  type        = list(string)
  default     = null
}

variable "node_pool_auto_config" {
  description = "Autopilot node pool auto-configuration."
  type = object({
    node_kubelet_config = optional(object({
      insecure_kubelet_readonly_port_enabled = optional(bool)
    }))
    resource_manager_tags = optional(map(string))
    network_tags = optional(object({
      tags = optional(list(string))
    }))
    linux_node_config = optional(object({
      cgroup_mode = optional(string)
    }))
  })
  default = {
    node_kubelet_config = {
      insecure_kubelet_readonly_port_enabled = false
    }
    linux_node_config = {
      cgroup_mode = "CGROUP_MODE_V2"
    }
  }
}

variable "security_posture_config" {
  description = "GKE Security Posture configuration."
  type = object({
    mode               = optional(string)
    vulnerability_mode = optional(string)
  })
  default = {
    mode               = "BASIC"
    vulnerability_mode = "VULNERABILITY_BASIC"
  }
}

variable "service_external_ips_config" {
  description = "Controls External IP usage in Services."
  type = object({
    enabled = optional(bool)
  })
  default = {
    enabled = false
  }
}

variable "timeouts" {
  description = "Timeouts for cluster operations."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}

variable "labels" {
  description = "Resource labels to apply to the cluster."
  type        = map(string)
  default     = {}
}
