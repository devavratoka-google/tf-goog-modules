variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnetwork_id" {
  type = string
}

## move this below subnetwork_id after testing
variable "vms" {
  description = "Map of VMs to create in this zone, where the key is the VM suffix (e.g., 'vm01') and value contains the static IP."
  type = map(object({
    address = string
  }))
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "source_image" {
  type    = string
  default = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2510-questing-amd64-v20251024"
}

variable "disk_size_gb" {
  type    = number
  default = 10
}

variable "disk_type" {
  type    = string
  default = "pd-balanced"
}

variable "vm_tags" {
  type    = list(string)
  default = ["nva"]
}

variable "resource_manager_tags" {
  type    = map(string)
  default = {}
}

variable "service_account_email" {
  type = string
}

variable "service_account_scopes" {
  type    = list(string)
  default = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append", "https://www.googleapis.com/auth/cloud-platform"]
}

variable "can_ip_forward" {
  type    = bool
  default = true
}

variable "desired_status" {
  type    = string
  default = "RUNNING"
}

variable "health_check_port" {
  type    = number
  default = 80
}
