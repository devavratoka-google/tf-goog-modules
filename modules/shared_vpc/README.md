# Shared VPC Module

This module associates a service project with a Shared VPC host project.

## Usage

```hcl
module "shared_vpc" {
  source          = "./modules/shared_vpc"
  host_project    = "my-host-project"
  service_project = "my-service-project"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_shared_vpc_service_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_service_project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_host_project"></a> [host\_project](#input\_host\_project) | The ID of the project that will serve as a Shared VPC host project. | `string` | n/a | yes |
| <a name="input_service_project"></a> [service\_project](#input\_service\_project) | A list of project IDs that will be associated as Shared VPC service projects to the host project. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
