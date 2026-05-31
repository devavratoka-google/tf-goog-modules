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
| [google_compute_subnetwork_iam_binding.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_members"></a> [members](#input\_members) | Identities that will be granted the privilege in role. | `set(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the project will be parsed from the identifier of the parent resource. If no project is provided in the parent identifier and no project is specified, the provider project is used. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for this subnetwork. Used to find the parent resource to bind the IAM policy to. If not specified, the value will be parsed from the identifier of the parent resource. If no region is provided in the parent identifier and no region is specified, it is taken from the provider configuration. | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | The role that should be applied. Only one google\_compute\_subnetwork\_iam\_binding can be used per role. Note that custom roles must be of the format [projects\|organizations]/{parent-name}/roles/{role-name}. | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Used to find the parent resource to bind the IAM policy to | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
