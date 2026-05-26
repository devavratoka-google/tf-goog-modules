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

## Outputs

| name | description |
|---|---|
| `id` | Fully qualified role id (usable in `role` of any IAM binding). |
| `name` | Same as `id` (fabric naming compatibility). |
| `role_id` | Short id (last path segment). |
| `permissions` | Permissions list. |
| `scope` | `"project"` or `"organization"`. |
