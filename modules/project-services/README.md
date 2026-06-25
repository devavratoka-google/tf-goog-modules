# Project Services Module

This module enables a list of Google Cloud APIs/services on a project and can optionally retrieve or create service identities.

## Usage

```hcl
module "project_services" {
  source     = "./modules/project-services"
  project_id = "my-project-id"
  services   = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}
```

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
| [google-beta_google_project_service_identity.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_service_identity) | resource |
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_disable_dependent_services"></a> [disable\_dependent\_services](#input\_disable\_dependent\_services) | Whether to disable dependent services when disabling this service. | `bool` | `false` | no |
| <a name="input_disable_on_destroy"></a> [disable\_on\_destroy](#input\_disable\_on\_destroy) | Whether to disable the API when the resource is destroyed. Set to false for shared project APIs. | `bool` | `false` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_service_identities"></a> [service\_identities](#input\_service\_identities) | Map of service API => list of roles to grant to its service identity via google\_project\_service\_identity. | `map(list(string))` | `{}` | no |
| <a name="input_services"></a> [services](#input\_services) | List of GCP service API identifiers to enable (e.g. ["pubsub.googleapis.com", "run.googleapis.com"]). | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled_services"></a> [enabled\_services](#output\_enabled\_services) | Set of enabled service API identifiers. |
<!-- END_TF_DOCS -->
