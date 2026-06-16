project_id = "your-project-id"
location   = "your-region"

default_labels = {
  managed-by  = "terraform"
  environment = "test"
}

# This file is intentionally configured with public upstreams for testing.
# Replace public_repository with upstream_uri and upstream_credentials values
# when deploying against the customer's private JFrog repositories.
remote_repositories = {
  docker = {
    repository_id      = "dockerhub-remote-test"
    format             = "DOCKER"
    public_repository  = "DOCKER_HUB"
    description        = "Test Docker remote repository backed by Docker Hub."
    remote_description = "Docker Hub test upstream."
    labels = {
      upstream = "dockerhub"
    }
    upstream_credentials = null
    members = {
      readers = []
      writers = []
    }
  }

  maven = {
    repository_id      = "maven-central-remote-test"
    format             = "MAVEN"
    public_repository  = "MAVEN_CENTRAL"
    description        = "Test Maven remote repository backed by Maven Central."
    remote_description = "Maven Central test upstream."
    labels = {
      upstream = "maven-central"
    }
    upstream_credentials = null
    members = {
      readers = []
      writers = []
    }
  }

  npm = {
    repository_id      = "npmjs-remote-test"
    format             = "NPM"
    public_repository  = "NPMJS"
    description        = "Test NPM remote repository backed by npmjs."
    remote_description = "npmjs test upstream."
    labels = {
      upstream = "npmjs"
    }
    upstream_credentials = null
    members = {
      readers = []
      writers = []
    }
  }

  python = {
    repository_id      = "pypi-remote-test"
    format             = "PYTHON"
    public_repository  = "PYPI"
    description        = "Test Python remote repository backed by PyPI."
    remote_description = "PyPI test upstream."
    labels = {
      upstream = "pypi"
    }
    upstream_credentials = null
    members = {
      readers = []
      writers = []
    }
  }

  # Example JFrog private upstreams. Uncomment and customize for the customer.
  # jfrog_docker = {
  #   repository_id    = "jfrog-docker-remote"
  #   format           = "DOCKER"
  #   upstream_uri     = "https://your-company.jfrog.io/artifactory/docker-virtual"
  #   labels = {
  #     upstream = "jfrog"
  #   }
  #   upstream_credentials = {
  #     username                = "artifact-registry-reader"
  #     password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
  #   }
  #   # Leave these lists empty to avoid granting repository-level IAM from this module.
  #   # Access still depends on IAM roles granted at the repository, project, folder, or organization level.
  #   members = {
  #     readers = []
  #     writers = []
  #   }
  # }

  # jfrog_maven = {
  #   repository_id    = "jfrog-maven-remote"
  #   format           = "MAVEN"
  #   upstream_uri     = "https://your-company.jfrog.io/artifactory/maven-virtual"
  #   labels = {
  #     upstream = "jfrog"
  #   }
  #   upstream_credentials = {
  #     username                = "artifact-registry-reader"
  #     password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
  #   }
  #   # Leave these lists empty to avoid granting repository-level IAM from this module.
  #   # Access still depends on IAM roles granted at the repository, project, folder, or organization level.
  #   members = {
  #     readers = []
  #     writers = []
  #   }
  # }

  # jfrog_npm = {
  #   repository_id    = "jfrog-npm-remote"
  #   format           = "NPM"
  #   upstream_uri     = "https://your-company.jfrog.io/artifactory/npm-virtual"
  #   labels = {
  #     upstream = "jfrog"
  #   }
  #   upstream_credentials = {
  #     username                = "artifact-registry-reader"
  #     password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
  #   }
  #   # Leave these lists empty to avoid granting repository-level IAM from this module.
  #   # Access still depends on IAM roles granted at the repository, project, folder, or organization level.
  #   members = {
  #     readers = []
  #     writers = []
  #   }
  # }

  # jfrog_python = {
  #   repository_id    = "jfrog-python-remote"
  #   format           = "PYTHON"
  #   upstream_uri     = "https://your-company.jfrog.io/artifactory/pypi-virtual"
  #   labels = {
  #     upstream = "jfrog"
  #   }
  #   upstream_credentials = {
  #     username                = "artifact-registry-reader"
  #     password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
  #   }
  #   # Leave these lists empty to avoid granting repository-level IAM from this module.
  #   # Access still depends on IAM roles granted at the repository, project, folder, or organization level.
  #   members = {
  #     readers = []
  #     writers = []
  #   }
  # }
}
