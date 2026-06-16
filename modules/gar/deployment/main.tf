terraform {
  required_version = ">= 1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.26.0, < 8"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.26.0, < 8"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.location
}

provider "google-beta" {
  project = var.project_id
  region  = var.location
}

locals {
  remote_repositories = {
    for key, repository in var.remote_repositories : key => merge(repository, {
      format = upper(repository.format)
      labels = merge(var.default_labels, repository.labels)
      has_upstream_credentials = (
        repository.upstream_credentials != null &&
        repository.upstream_credentials.username != null &&
        repository.upstream_credentials.password_secret_version != null
      )
    })
  }
}

module "remote_repositories" {
  for_each = local.remote_repositories

  source = "../"

  project_id    = var.project_id
  location      = var.location
  repository_id = each.value.repository_id
  format        = each.value.format
  mode          = "REMOTE_REPOSITORY"
  description   = each.value.description
  labels        = each.value.labels
  members       = each.value.members

  remote_repository_config = {
    description                 = each.value.remote_description
    disable_upstream_validation = each.value.disable_upstream_validation
    upstream_credentials = each.value.has_upstream_credentials ? {
      username                = each.value.upstream_credentials.username
      password_secret_version = each.value.upstream_credentials.password_secret_version
    } : null

    docker_repository = each.value.format == "DOCKER" ? {
      public_repository = each.value.public_repository
      custom_repository = each.value.upstream_uri != null ? {
        uri = each.value.upstream_uri
      } : null
    } : null

    maven_repository = each.value.format == "MAVEN" ? {
      public_repository = each.value.public_repository
      custom_repository = each.value.upstream_uri != null ? {
        uri = each.value.upstream_uri
      } : null
    } : null

    npm_repository = each.value.format == "NPM" ? {
      public_repository = each.value.public_repository
      custom_repository = each.value.upstream_uri != null ? {
        uri = each.value.upstream_uri
      } : null
    } : null

    python_repository = each.value.format == "PYTHON" ? {
      public_repository = each.value.public_repository
      custom_repository = each.value.upstream_uri != null ? {
        uri = each.value.upstream_uri
      } : null
    } : null
  }
}

output "artifact_ids" {
  description = "Artifact Registry repository IDs by remote repository key."
  value = {
    for key, repository in module.remote_repositories : key => repository.artifact_id
  }
}

output "artifact_names" {
  description = "Artifact Registry repository resource names by remote repository key."
  value = {
    for key, repository in module.remote_repositories : key => repository.artifact_name
  }
}
