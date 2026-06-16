# Remote Repositories on Google Artifact Registry

This deployment creates Google Artifact Registry remote repositories. It is designed for the customer JFrog use case, but the checked-in test configuration uses public upstreams so the Terraform code can be validated without access to JFrog.

The deployment does not create Artifact Registry resources directly. It calls the local module in the parent folder with `source = "../"`.

## Prerequisites

Before running this deployment, the customer environment must have:

- A Google Cloud project selected for the repositories.
- Billing enabled on that project.
- Terraform authentication configured for the project.
- Artifact Registry API enabled: `artifactregistry.googleapis.com`.
- Permission to create Artifact Registry repositories.
- Permission to manage repository-level IAM bindings if `members` is configured.
- Secret Manager API enabled if private JFrog credentials will be used: `secretmanager.googleapis.com`.

For private JFrog upstreams, the customer must also have:

- A JFrog repository URL for each package format.
- A JFrog username and token/password.
- A Secret Manager secret version containing the JFrog token/password.
- `roles/secretmanager.secretAccessor` granted to the Artifact Registry service agent on that secret.

The Artifact Registry service agent uses this format:

```text
service-PROJECT_NUMBER@gcp-sa-artifactregistry.iam.gserviceaccount.com
```

Example Secret Manager IAM grant:

```bash
gcloud secrets add-iam-policy-binding jfrog-token \
  --project your-project-id \
  --member "serviceAccount:service-PROJECT_NUMBER@gcp-sa-artifactregistry.iam.gserviceaccount.com" \
  --role "roles/secretmanager.secretAccessor"
```

## Current Test Configuration

The checked-in `terraform.tfvars` creates four remote repositories in the project configured by `project_id`:

| Key | Artifact Registry repo | Format | Test upstream |
| --- | --- | --- | --- |
| `docker` | `dockerhub-remote-test` | `DOCKER` | `DOCKER_HUB` |
| `maven` | `maven-central-remote-test` | `MAVEN` | `MAVEN_CENTRAL` |
| `npm` | `npmjs-remote-test` | `NPM` | `NPMJS` |
| `python` | `pypi-remote-test` | `PYTHON` | `PYPI` |

These are public upstreams. They are useful for validating repository creation, IAM, remote repository behavior, and package pulls without having a JFrog instance available.

For JFrog, replace `public_repository` with `upstream_uri` and add `upstream_credentials` when the upstream is private.

## What We Are Building

The deployment creates one Artifact Registry remote repository per entry in `remote_repositories`.

Each repository has:

- `mode = "REMOTE_REPOSITORY"`
- A package format: `DOCKER`, `MAVEN`, `NPM`, or `PYTHON`
- Either a public upstream enum, such as `DOCKER_HUB`, or a custom upstream URI, such as a JFrog URL
- Optional upstream credentials from Secret Manager
- Optional reader/writer IAM bindings
- Labels for ownership, environment, and upstream tracking

The flow is:

```text
Customer workload
  -> Google Artifact Registry remote repository
    -> Public upstream or JFrog upstream repository
```

Remote repositories cache artifacts from the upstream. They do not publish new artifacts to the upstream.

## Repository Layout

```text
terraform-google-artifact-registry/
  main.tf              # reusable module: creates google_artifact_registry_repository
  variables.tf         # module inputs
  outputs.tf           # module outputs

  deployment/
    main.tf            # customer deployment: calls the parent module
    variables.tf       # deployment input schema
    terraform.tfvars   # test/customer values
    README.md
```

## Which Module We Are Calling

`deployment/main.tf` calls the parent module like this:

```hcl
module "remote_repositories" {
  for_each = local.remote_repositories

  source = "../"

  project_id    = var.project_id
  location      = var.location
  repository_id = each.value.repository_id
  format        = each.value.format
  mode          = "REMOTE_REPOSITORY"
}
```

The important part is:

```hcl
source = "../"
```

Because `deployment/main.tf` is inside `terraform-google-artifact-registry/deployment`, `../` points to:

```text
terraform-google-artifact-registry/
```

That parent folder is the module based on `GoogleCloudPlatform/terraform-google-artifact-registry`. The parent module creates the actual resource:

```hcl
resource "google_artifact_registry_repository" "repo" {
  ...
}
```

## How Multiple Repositories Are Created

The deployment uses `for_each` over `var.remote_repositories`.

Example:

```hcl
remote_repositories = {
  docker = {
    repository_id     = "dockerhub-remote-test"
    format            = "DOCKER"
    public_repository = "DOCKER_HUB"
  }

  maven = {
    repository_id     = "maven-central-remote-test"
    format            = "MAVEN"
    public_repository = "MAVEN_CENTRAL"
  }
}
```

This creates two module instances:

```text
module.remote_repositories["docker"]
module.remote_repositories["maven"]
```

Each module instance creates one Artifact Registry repository.

## Public Test Upstreams

Use `public_repository` for Google-supported public upstreams:

```hcl
remote_repositories = {
  docker = {
    repository_id     = "dockerhub-remote-test"
    format            = "DOCKER"
    public_repository = "DOCKER_HUB"
  }

  maven = {
    repository_id     = "maven-central-remote-test"
    format            = "MAVEN"
    public_repository = "MAVEN_CENTRAL"
  }

  npm = {
    repository_id     = "npmjs-remote-test"
    format            = "NPM"
    public_repository = "NPMJS"
  }

  python = {
    repository_id     = "pypi-remote-test"
    format            = "PYTHON"
    public_repository = "PYPI"
  }
}
```

## JFrog Custom Upstreams

Use `upstream_uri` for JFrog or any custom upstream repository.

Example with four private JFrog upstreams:

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
  }

  jfrog_maven = {
    repository_id = "jfrog-maven-remote"
    format        = "MAVEN"
    upstream_uri  = "https://your-company.jfrog.io/artifactory/maven-virtual"
    labels = {
      upstream = "jfrog"
    }
    upstream_credentials = {
      username                = "artifact-registry-reader"
      password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
    }
  }

  jfrog_npm = {
    repository_id = "jfrog-npm-remote"
    format        = "NPM"
    upstream_uri  = "https://your-company.jfrog.io/artifactory/npm-virtual"
    labels = {
      upstream = "jfrog"
    }
    upstream_credentials = {
      username                = "artifact-registry-reader"
      password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
    }
  }

  jfrog_python = {
    repository_id = "jfrog-python-remote"
    format        = "PYTHON"
    upstream_uri  = "https://your-company.jfrog.io/artifactory/pypi-virtual"
    labels = {
      upstream = "jfrog"
    }
    upstream_credentials = {
      username                = "artifact-registry-reader"
      password_secret_version = "projects/your-project-id/secrets/jfrog-token/versions/latest"
    }
  }
}
```

Set exactly one of these per repository:

- `public_repository` for public upstreams such as Docker Hub, Maven Central, npmjs, or PyPI
- `upstream_uri` for JFrog or another custom upstream

## Values The Customer Must Customize

| Variable | Required | Description |
| --- | --- | --- |
| `project_id` | Yes | Google Cloud project where repositories are created. |
| `location` | Yes | Artifact Registry location or region. |
| `default_labels` | No | Labels applied to every remote repository. |
| `remote_repositories` | Yes | Map of repositories to create. |
| `remote_repositories[*].repository_id` | Yes | Artifact Registry repository name. |
| `remote_repositories[*].format` | Yes | One of `DOCKER`, `MAVEN`, `NPM`, `PYTHON`. |
| `remote_repositories[*].public_repository` | Conditional | Public upstream enum. Use only when not using `upstream_uri`. |
| `remote_repositories[*].upstream_uri` | Conditional | Custom upstream URI, normally JFrog. Use only when not using `public_repository`. |
| `remote_repositories[*].upstream_credentials` | Conditional | Required for private JFrog upstreams. |
| `remote_repositories[*].members` | No | Repository-level IAM readers and writers. |

## IAM Access

Use `members` inside each repository to grant Artifact Registry access:

```hcl
members = {
  readers = [
    "group:developers@example.com"
  ]
  writers = [
    "serviceAccount:ci-deployer@your-project-id.iam.gserviceaccount.com"
  ]
}
```

The parent module maps these to:

- `roles/artifactregistry.reader` for `readers`
- `roles/artifactregistry.writer` for `writers`

For remote repositories, most consumers only need reader access.

## Deployment Commands

Run commands from this folder:

```bash
cd terraform-google-artifact-registry/deployment
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

For environment-specific variable files:

```bash
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

## Consuming The Test Repositories

After applying the test configuration, consumers authenticate to Artifact Registry and use the Artifact Registry repository endpoint instead of the upstream endpoint directly.

The examples below use placeholders:

- `REGION`: Artifact Registry location, for example `us-central1`
- `PROJECT_ID`: Google Cloud project ID
- `REPOSITORY_ID`: Artifact Registry repository ID created by this Terraform deployment

### Docker

```bash
gcloud auth configure-docker REGION-docker.pkg.dev
docker pull REGION-docker.pkg.dev/PROJECT_ID/dockerhub-remote-test/busybox:latest
```

The Docker image must exist in Docker Hub. The Artifact Registry repository name, `dockerhub-remote-test`, only exists in Google Cloud.

### Maven

For Maven remote repositories, configure the repository in `pom.xml`.

For a Maven Central remote repository, the repository ID should be `central` so it overrides Maven's default central repository entry:

```xml
<repositories>
  <repository>
    <id>central</id>
    <name>Artifact Registry Maven Central remote</name>
    <url>artifactregistry://REGION-maven.pkg.dev/PROJECT_ID/maven-central-remote-test</url>
    <layout>default</layout>
    <releases>
      <enabled>true</enabled>
    </releases>
    <snapshots>
      <enabled>true</enabled>
    </snapshots>
  </repository>
</repositories>
```

Then build normally:

```bash
mvn dependency:resolve
```

The Maven dependency must exist in Maven Central, because `maven-central-remote-test` is a remote repository backed by Maven Central in the test configuration.

### NPM

For NPM repositories, use the Artifact Registry npm endpoint:

```text
https://REGION-npm.pkg.dev/PROJECT_ID/npmjs-remote-test/
```

You can print the recommended npm settings with:

```bash
gcloud artifacts print-settings npm \
  --project=PROJECT_ID \
  --location=REGION \
  --repository=npmjs-remote-test \
  --scope=@your-scope
```

For a scoped package, configure `.npmrc`:

```ini
@your-scope:registry=https://REGION-npm.pkg.dev/PROJECT_ID/npmjs-remote-test/
```

Then authenticate using the Artifact Registry npm credential helper:

```bash
npm_config_registry=https://registry.npmjs.org npx google-artifactregistry-auth
```

Install a package through the Artifact Registry remote repository:

```bash
npm install @your-scope/package-name
```

For unscoped packages, set the npm registry to the Artifact Registry repository endpoint instead of configuring a scope.

### Python

For Python repositories, configure `pip` to use the Artifact Registry Simple Repository API endpoint:

```text
https://REGION-python.pkg.dev/PROJECT_ID/pypi-remote-test/simple/
```

You can print the recommended Python settings with:

```bash
gcloud artifacts print-settings python \
  --project=PROJECT_ID \
  --location=REGION \
  --repository=pypi-remote-test
```

Example `pip.conf`:

```ini
[global]
index-url = https://REGION-python.pkg.dev/PROJECT_ID/pypi-remote-test/simple/
```

Then install a package that exists in PyPI:

```bash
pip install requests
```

The package must exist in PyPI, because `pypi-remote-test` is a remote repository backed by PyPI in the test configuration.

### Runtime IAM

For all package formats, the user or service account consuming the repository needs Artifact Registry read access, such as `roles/artifactregistry.reader`, granted at the repository, project, folder, or organization level.

## Expected Result

After `terraform apply`, the project will have one Artifact Registry remote repository per `remote_repositories` entry.

Resource names follow this pattern:

```text
projects/PROJECT_ID/locations/LOCATION/repositories/REPOSITORY_ID
```

Example:

```text
projects/your-project-id/locations/REGION/repositories/dockerhub-remote-test
```

## Important Notes

Remote repositories are for consuming and caching upstream artifacts. They are not used to publish new packages.

If the customer needs to publish their own packages, create a separate `STANDARD_REPOSITORY`.

If the customer wants one Google Cloud endpoint that aggregates multiple repositories, create multiple remote repositories first and then add an Artifact Registry virtual repository on top of them.
