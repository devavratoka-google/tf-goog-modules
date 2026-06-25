# Project IAM

Grants one IAM role to one or more members on a GCP project using additive
(`google_project_iam_member`) bindings. Supports optional IAM conditions.

This module is intentionally narrow: it manages a **single role** per
invocation. For cross-project grants or external-SA grants that don't belong
inside the service account module, call this module once per role.

## Usage

```hcl
module "invoker_grant" {
  source = "./modules/project-iam"

  project_id = "my-project-id"
  role       = "roles/run.invoker"
  members    = [
    "serviceAccount:my-sa@my-project-id.iam.gserviceaccount.com",
  ]
}

# With an IAM condition
module "conditional_grant" {
  source = "./modules/project-iam"

  project_id = "my-project-id"
  role       = "roles/storage.objectViewer"
  members    = ["serviceAccount:etl@my-project-id.iam.gserviceaccount.com"]

  condition = {
    title      = "bucket-prefix-only"
    expression = "resource.name.startsWith(\"projects/_/buckets/my-bucket/objects/exports/\")"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID to grant the IAM binding on. | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | IAM role to grant (e.g. roles/run.invoker). | `string` | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | List of IAM members to grant the role (e.g. serviceAccount:foo@bar.iam.gserviceaccount.com). | `list(string)` | n/a | yes |
| <a name="input_condition"></a> [condition](#input\_condition) | Optional IAM condition. Set to null for unconditional bindings. | <pre>object({<br/>    title       = string<br/>    description = optional(string)<br/>    expression  = string<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_members"></a> [members](#output\_members) | The IAM members granted the role. |
<!-- END_TF_DOCS -->
