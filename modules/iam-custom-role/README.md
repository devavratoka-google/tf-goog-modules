# IAM Custom Role (local)

Thin local module that creates a GCP IAM custom role, scoped either to a
single project (`google_project_iam_custom_role`) or to an organization
(`google_organization_iam_custom_role`).

Custom roles are first-class GCP objects with their own lifecycle: they exist
independently of the principals (users, SAs, groups) that consume them. This
module is intentionally kept separate from
[`iam-service-account`](../iam-service-account) so the role's lifecycle does
not get coupled to any single service account.

## Usage

### Standalone

```hcl
module "vm_runtime_reader" {
  source = "./modules/iam-custom-role"

  project_id  = "my-project"
  role_id     = "vmRuntimeReader"
  title       = "VM Runtime Reader"
  description = "Permissions a GCE VM runtime SA needs."
  permissions = [
    "logging.logEntries.create",
    "monitoring.timeSeries.create",
  ]
}
```

Outputs:

- `id` / `name` -> `projects/my-project/roles/vmRuntimeReader` (use this in
  any IAM binding's `role` field).
- `role_id` -> `vmRuntimeReader`.
- `scope` -> `project` or `organization`.

### Integration with `iam-service-account`

The companion module [`iam-service-account`](../iam-service-account) already
supports symbolic role references via `context.custom_roles`. In the root
[`main.tf`](../../main.tf) the outputs of all `module "iam_custom_role"`
instances are merged into the `context.custom_roles` of every
`module "iam_service_account"` automatically. That means you can write in
`env.tfvars`:

```hcl
iam_custom_roles = {
  "vmRuntimeReader" = {
    project_id  = "my-project"
    role_id     = "vmRuntimeReader"
    title       = "VM Runtime Reader"
    permissions = ["logging.logEntries.create", "monitoring.timeSeries.create"]
  }
}

iam_service_accounts = {
  "vm-runtime" = {
    name       = "vm-runtime"
    project_id = "my-project"
    iam_project_roles = {
      "my-project" = ["$custom_roles:vmRuntimeReader"]
    }
  }
}
```

At plan time `$custom_roles:vmRuntimeReader` resolves to
`projects/my-project/roles/vmRuntimeReader`. Terraform's dependency graph
ensures the custom role is created before the binding tries to reference it.

## Scopes

Exactly one of `project_id` or `org_id` must be set (validated). The same
module file handles both scopes via two resource blocks gated by `count`.

## Soft delete and `role_id` reuse

When destroyed, GCP keeps the custom role in a deleted state for ~7 days
before purging it. Recreating with the same `role_id` in that window can be
awkward. For production roles, consider adding a `lifecycle { prevent_destroy
= true }` block in a wrapper or pinning the role outside ephemeral state.

## Variables

| name | type | required | default |
|---|---|---|---|
| `role_id` | string | yes | - |
| `title` | string | yes | - |
| `permissions` | list(string) | yes | - |
| `description` | string | no | null |
| `stage` | string | no | `"GA"` |
| `project_id` | string | one of | null |
| `org_id` | string | one of | null |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_organization_iam_custom_role.role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_custom_role) | resource |
| [google_project_iam_custom_role.role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Optional human-readable description. | `string` | `null` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Organization id where this custom role lives. Mutually exclusive with project\_id. | `string` | `null` | no |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | List of GCP permissions (e.g. 'bigquery.datasets.get') granted by this custom role. | `list(string)` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where this custom role lives. Mutually exclusive with org\_id. | `string` | `null` | no |
| <a name="input_role_id"></a> [role\_id](#input\_role\_id) | The role id to use for this role. Must be camelCase, 3-64 chars, alphanumeric+underscores. Final role name is 'projects/{project}/roles/{role\_id}' or 'organizations/{org}/roles/{role\_id}'. | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Launch stage of the custom role. One of ALPHA, BETA, GA, DEPRECATED, DISABLED, EAP. | `string` | `"GA"` | no |
| <a name="input_title"></a> [title](#input\_title) | Human-readable title shown in the GCP IAM console. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Fully qualified custom role id, usable directly in IAM bindings (e.g. 'projects/X/roles/myRole' or 'organizations/Y/roles/myRole'). |
| <a name="output_name"></a> [name](#output\_name) | Fully qualified custom role name. Same value as id; provided for naming compatibility with fabric modules. |
| <a name="output_permissions"></a> [permissions](#output\_permissions) | Permissions granted by this custom role. |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | Short role id (last path segment, e.g. 'myRole'). |
| <a name="output_scope"></a> [scope](#output\_scope) | Scope of the custom role: 'project' or 'organization'. |
<!-- END_TF_DOCS -->
