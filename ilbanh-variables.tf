variable "env_project_id" {
  type    = string
  default = "<proj-id>"
}

variable "nva_clusters" {
  description = "Map of NVA clusters to deploy across regions"
  type = map(object({
    name                  = string
    region                = string
    zone                  = string
    network_id            = string
    subnetwork_id         = string
    resource_manager_tags = map(string)
    vms = map(object({
      address = string
    }))
  }))
}