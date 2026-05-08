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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| host_project | The ID of the project that will serve as a Shared VPC host project | `string` | n/a | yes |
| service_project | The ID of the project that will be associated as a service project | `string` | n/a | yes |

## Outputs

No outputs.
