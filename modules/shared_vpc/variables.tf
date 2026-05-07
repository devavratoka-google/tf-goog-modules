variable "host_project" {
  type        = string
  description = "The ID of the project that will serve as a Shared VPC host project."
}

variable "service_project" {
  #   type = map(object({}))
  type        = string
  description = "A list of project IDs that will be associated as Shared VPC service projects to the host project."
}