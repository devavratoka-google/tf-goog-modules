variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the project will be parsed from the identifier of the parent resource. If no project is provided in the parent identifier and no project is specified, the provider project is used."
}

variable "region" {
  type        = string
  description = "The GCP region for this subnetwork. Used to find the parent resource to bind the IAM policy to. If not specified, the value will be parsed from the identifier of the parent resource. If no region is provided in the parent identifier and no region is specified, it is taken from the provider configuration."
}

variable "subnetwork" {
  type        = string
  description = "Used to find the parent resource to bind the IAM policy to"
}

variable "role" {
  type        = string
  description = "The role that should be applied. Only one google_compute_subnetwork_iam_binding can be used per role. Note that custom roles must be of the format [projects|organizations]/{parent-name}/roles/{role-name}."
}

variable "members" {
  type        = set(string)
  description = "Identities that will be granted the privilege in role."
}
