# Subnet IAM Binding Module

This module creates an IAM binding for a Google Cloud Compute Subnetwork.

## Usage

```hcl
module "subnet_iam_binding" {
  source     = "./modules/subnet_iam_binding"
  project    = "my-project-id"
  region     = "us-central1"
  subnetwork = "my-subnet"
  role       = "roles/compute.networkUser"
  members    = ["user:foo@example.com"]
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
| project | The ID of the project in which the resource belongs | `string` | n/a | yes |
| region | The GCP region for this subnetwork | `string` | n/a | yes |
| subnetwork | Used to find the parent resource to bind the IAM policy to | `string` | n/a | yes |
| role | The role that should be applied | `string` | n/a | yes |
| members | Identities that will be granted the privilege in role | `set(string)` | n/a | yes |

## Outputs

No outputs.
