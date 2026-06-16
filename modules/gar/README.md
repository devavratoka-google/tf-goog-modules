# Google Artifact Registry (GAR) — Deployment Guide

This guide explains how to use the `deployment/` folder to create [Google Artifact Registry](https://cloud.google.com/artifact-registry) Remote repositories on Google Cloud.

> **You only need to work inside `deployment/`.** The files at the `gar/` root (`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`) are the **reusable Terraform module** that `deployment/main.tf` calls internally via `source = "../"`. You do not modify those files.

## How It Works

```text
modules/gar/
  ├── main.tf          ← reusable module (do not edit)
  ├── variables.tf     ← module input definitions (do not edit)
  ├── outputs.tf       ← module outputs (do not edit)
  ├── versions.tf      ← provider version constraints (do not edit)
  │
  └── deployment/      ←  ENTRY POINT — work here
        ├── main.tf            calls source = "../" for each repository entry
        ├── variables.tf       input schema for this deployment
        └── terraform.tfvars   values to customize before applying
```

`deployment/main.tf` iterates over `var.remote_repositories` using `for_each` and calls the parent module once per repository:

```hcl
module "remote_repositories" {
  for_each = local.remote_repositories

  source = "../"   # <-- calls modules/gar/

  project_id    = var.project_id
  location      = var.location
  repository_id = each.value.repository_id
  format        = each.value.format
  mode          = "REMOTE_REPOSITORY"
  ...
}
```

Each entry in `remote_repositories` results in one `google_artifact_registry_repository` resource created by the parent module.

---

## Requirements

| Tool | Minimum version |
|---|---|
| Terraform | `>= 1.3` |
| `hashicorp/google` | `>= 5.26.0, < 8` |
| `hashicorp/google-beta` | `>= 5.26.0, < 8` |

The following Google Cloud APIs must be enabled on the target project:

- `artifactregistry.googleapis.com`
- `secretmanager.googleapis.com` — only required when using private upstream credentials

---

## Deploying Remote Repositories

All commands are run from inside `deployment/`. The deployment provisions **one or more Remote repositories** that proxy and cache an external registry — such as Docker Hub, Maven Central, npmjs, PyPI, or a private JFrog instance.

### Step 1 — Navigate to the deployment folder

```bash
cd modules/gar/deployment
```

### Step 2 — Customize `terraform.tfvars`

Edit `terraform.tfvars` and replace the placeholder values:

```hcl
project_id = "your-project-id"
location   = "us-central1"

default_labels = {
  managed-by  = "terraform"
  environment = "production"
}
```

### Step 3 — Define repositories

Each entry in `remote_repositories` creates one Artifact Registry Remote repository.

#### Public upstreams (Docker Hub, Maven Central, npmjs, PyPI)

```hcl
remote_repositories = {
  docker = {
    repository_id     = "dockerhub-remote"
    format            = "DOCKER"
    public_repository = "DOCKER_HUB"
    description       = "Docker remote repository backed by Docker Hub."
  }

  maven = {
    repository_id     = "maven-central-remote"
    format            = "MAVEN"
    public_repository = "MAVEN_CENTRAL"
    description       = "Maven remote repository backed by Maven Central."
  }

  npm = {
    repository_id     = "npmjs-remote"
    format            = "NPM"
    public_repository = "NPMJS"
    description       = "NPM remote repository backed by npmjs."
  }

  python = {
    repository_id     = "pypi-remote"
    format            = "PYTHON"
    public_repository = "PYPI"
    description       = "Python remote repository backed by PyPI."
  }
}
```

#### Private JFrog upstreams

Replace `public_repository` with `upstream_uri` and supply `upstream_credentials`:

```hcl
remote_repositories = {
  jfrog_docker = {
    repository_id = "jfrog-docker-remote"
    format        = "DOCKER"
    upstream_uri  = "https://your-company.jfrog.io/artifactory/docker-virtual"
    labels = {
      upstream = "jfrog"
    }
    upstream_credentials = {
      username                = "artifact-registry-reader"
      password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
    }
    members = {
      readers = ["group:developers@example.com"]
      writers = []
    }
  }

  jfrog_npm = {
    repository_id = "jfrog-npm-remote"
    format        = "NPM"
    upstream_uri  = "https://your-company.jfrog.io/artifactory/npm-virtual"
    upstream_credentials = {
      username                = "artifact-registry-reader"
      password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
    }
    members = {}
  }
}
```

> **Rule:** each repository entry must set **exactly one** of `public_repository` or `upstream_uri`.

### Step 4 — Grant Secret Manager access (JFrog only)

The Artifact Registry service agent needs permission to read the JFrog token secret:

```bash
gcloud secrets add-iam-policy-binding jfrog-token \
  --project your-project-id \
  --member "serviceAccount:service-PROJECT_NUMBER@gcp-sa-artifactregistry.iam.gserviceaccount.com" \
  --role "roles/secretmanager.secretAccessor"
```

### Step 5 — Apply

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

For environment-specific variable files:

```bash
terraform plan  -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

---

## Input Variables (`deployment/`)

These are the only variables you need to configure. They are defined in `deployment/variables.tf` and set via `deployment/terraform.tfvars`.


| Variable | Type | Required | Default | Description |
|---|---|---|---|---|
| `project_id` | `string` | Yes | — | Google Cloud project ID |
| `location` | `string` | No | `southamerica-east1` | Artifact Registry location |
| `default_labels` | `map(string)` | No | `{ managed-by = "terraform" }` | Labels applied to every repository |
| `remote_repositories` | `map(object)` | Yes | — | Map of Remote repositories to create (see below) |

Each `remote_repositories` entry supports:

| Field | Required | Description |
|---|---|---|
| `repository_id` | Yes | Artifact Registry repository name |
| `format` | Yes | `DOCKER`, `MAVEN`, `NPM`, or `PYTHON` |
| `public_repository` | Conditional | Public upstream enum (e.g. `DOCKER_HUB`, `PYPI`) |
| `upstream_uri` | Conditional | Custom upstream URI (e.g. a JFrog URL) |
| `description` | No | Repository description |
| `remote_description` | No | Upstream description |
| `disable_upstream_validation` | No | Skip upstream validation (`false` by default) |
| `labels` | No | Additional labels merged with `default_labels` |
| `upstream_credentials` | No | `username` + `password_secret_version` for private upstreams |
| `members` | No | `readers` / `writers` IAM bindings |

---

## Outputs

After `terraform apply`, the deployment exposes the following outputs (keyed by the `remote_repositories` map key):

| Output | Description |
|---|---|
| `artifact_ids` | Map of repository full resource IDs |
| `artifact_names` | Map of repository resource names |

---

## IAM Bindings

The module assigns roles at the repository level via `members`:

```hcl
members = {
  readers = ["group:developers@example.com"]
  writers = ["serviceAccount:ci-sa@project.iam.gserviceaccount.com"]
}
```

| Key | Role granted |
|---|---|
| `readers` | `roles/artifactregistry.reader` |
| `writers` | `roles/artifactregistry.writer` |

Leave `members = {}` to manage IAM outside this module.

---

## Cleanup Policies

Cleanup policies automatically delete old or untagged versions:

```hcl
cleanup_policy_dry_run = false

cleanup_policies = {
  delete-old-untagged = {
    action = "DELETE"
    condition = {
      tag_state  = "UNTAGGED"
      older_than = "2592000s" # 30 days
    }
  }

  keep-last-5 = {
    action = "KEEP"
    most_recent_versions = {
      keep_count = 5
    }
  }
}
```

Set `cleanup_policy_dry_run = true` to preview deletions without removing any versions.

---

## Consuming Remote Repositories

After `terraform apply`, use the Artifact Registry endpoint instead of the upstream directly.

### Docker

```bash
gcloud auth configure-docker REGION-docker.pkg.dev
docker pull REGION-docker.pkg.dev/PROJECT_ID/REPOSITORY_ID/busybox:latest
```

### Maven — `pom.xml`

```xml
<repositories>
  <repository>
    <id>central</id>
    <url>artifactregistry://REGION-maven.pkg.dev/PROJECT_ID/REPOSITORY_ID</url>
  </repository>
</repositories>
```

### NPM — `.npmrc`

```ini
@your-scope:registry=https://REGION-npm.pkg.dev/PROJECT_ID/REPOSITORY_ID/
```

```bash
npm_config_registry=https://registry.npmjs.org npx google-artifactregistry-auth
npm install @your-scope/package-name
```

### Python — `pip.conf`

```ini
[global]
index-url = https://REGION-python.pkg.dev/PROJECT_ID/REPOSITORY_ID/simple/
```

```bash
pip install requests
```

---

## Notes

- Remote repositories **cache** artifacts from the upstream. They do not publish new packages to the upstream.
- The `deployment/terraform.tfvars` file ships with public upstreams (Docker Hub, Maven Central, npmjs, PyPI) for validation purposes. Replace with your JFrog or other private upstream values before deploying to production.
- The parent module files at `modules/gar/` (`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`) are called automatically by `deployment/main.tf` via `source = "../"`. You do not need to modify them.
