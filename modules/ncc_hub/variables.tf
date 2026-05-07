################ Variables for NCC Hub ################

variable "name" {
  type        = string
  description = "(Required) Immutable. The name of the hub. Hub names must be unique. They use the following form: projects/{project_number}/locations/global/hubs/{hub_id}"
}

variable "description" {
  type        = string
  description = "An optional description of the hub."
}

variable "labels" {
  type        = map(string)
  description = "Optional labels in key:value format."
}

variable "preset_topology" {
  type        = string
  description = "The topology implemented in this hub. Currently, this field is only used when policyMode = PRESET. The available preset topologies are MESH and STAR. If presetTopology is unspecified and policyMode = PRESET, the presetTopology defaults to MESH. When policyMode = CUSTOM, the presetTopology is set to PRESET_TOPOLOGY_UNSPECIFIED. Possible values are: MESH, STAR."
}

variable "export_psc" {
  type        = bool
  description = "Whether Private Service Connect transitivity is enabled for the hub. If true, Private Service Connect endpoints in VPC spokes attached to the hub are made accessible to other VPC spokes attached to the hub. The default value is false."
}

variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

################ Variables for NCC Group ################

variable "ncc_groups" {
  type = map(object({
    description          = string
    auto_accept_projects = list(string)
  }))
  description = "A map of NCC groups to create."
}