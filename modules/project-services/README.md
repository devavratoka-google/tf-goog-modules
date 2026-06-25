# Project Services

Enables one or more GCP service APIs on a project and optionally provisions
their service identities so downstream IAM grants can reference the identity
email immediately after `terraform apply`.

The resources this module creates:

- `google_project_service` — one resource per entry in `services`
- `google_project_service_identity` — one resource per key in
  `service_identities` (requires `google-beta` provider; depends on the
  corresponding service being enabled)

## Usage

```hcl
# Enable APIs only
module "apis" {
  source = "./modules/project-services"

  project_id = "my-project-id"
  services   = [
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudscheduler.googleapis.com",
  ]
}

# Enable APIs and provision service identities for downstream IAM
module "apis_with_identities" {
  source = "./modules/project-services"

  project_id = "my-project-id"
  services   = [
    "pubsub.googleapis.com",
    "storage.googleapis.com",
  ]

  service_identities = {
    "pubsub.googleapis.com"  = ["roles/storage.objectCreator"]
    "storage.googleapis.com" = []
  }
}
```

`disable_on_destroy` defaults to `false` to prevent accidental API teardown in
shared projects when Terraform removes a module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service_identity.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/project_service_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID. | `string` | n/a | yes |
| <a name="input_services"></a> [services](#input\_services) | List of GCP service API identifiers to enable (e.g. ["pubsub.googleapis.com", "run.googleapis.com"]). | `list(string)` | n/a | yes |
| <a name="input_disable_on_destroy"></a> [disable\_on\_destroy](#input\_disable\_on\_destroy) | Whether to disable the API when the resource is destroyed. Set to false for shared project APIs. | `bool` | `false` | no |
| <a name="input_disable_dependent_services"></a> [disable\_dependent\_services](#input\_disable\_dependent\_services) | Whether to disable dependent services when disabling this service. | `bool` | `false` | no |
| <a name="input_service_identities"></a> [service\_identities](#input\_service\_identities) | Map of service API => list of roles to grant to its service identity via google\_project\_service\_identity. | `map(list(string))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled_services"></a> [enabled\_services](#output\_enabled\_services) | Set of enabled service API identifiers. |
<!-- END_TF_DOCS -->
