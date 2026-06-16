variable "project_id" {
  description = "Google Cloud project ID where the Artifact Registry remote repositories will be created."
  type        = string
}

variable "location" {
  description = "Artifact Registry location."
  type        = string
  default     = "southamerica-east1"
}

variable "default_labels" {
  description = "Default labels applied to every Artifact Registry remote repository."
  type        = map(string)
  default = {
    managed-by = "terraform"
  }
}

variable "remote_repositories" {
  description = "Artifact Registry remote repositories to create, keyed by a friendly name such as docker, maven, npm, or python."
  type = map(object({
    repository_id     = string
    format            = string
    public_repository = optional(string, null)
    upstream_uri      = optional(string, null)

    description                 = optional(string, "Remote Artifact Registry repository.")
    remote_description          = optional(string, "Remote upstream repository.")
    disable_upstream_validation = optional(bool, false)
    labels                      = optional(map(string), {})

    upstream_credentials = optional(object({
      username                = string
      password_secret_version = string
    }), null)

    members = optional(map(list(string)), {})
  }))

  validation {
    condition = alltrue([
      for repository in values(var.remote_repositories) :
      contains(["DOCKER", "MAVEN", "NPM", "PYTHON"], upper(repository.format))
    ])
    error_message = "Each remote repository format must be one of: DOCKER, MAVEN, NPM, PYTHON."
  }

  validation {
    condition = alltrue([
      for repository in values(var.remote_repositories) :
      (repository.public_repository != null) != (repository.upstream_uri != null)
    ])
    error_message = "Each remote repository must set exactly one of public_repository or upstream_uri."
  }

  validation {
    condition = alltrue(flatten([
      for repository in values(var.remote_repositories) : [
        for key in keys(repository.members) : contains(["readers", "writers"], key)
      ]
    ]))
    error_message = "The supported members keys are readers and writers."
  }
}
