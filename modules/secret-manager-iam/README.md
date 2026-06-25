# Secret Manager IAM

Grants an IAM role on an **existing** Secret Manager secret to one or more
members. Use this module when the secret was provisioned out-of-band (e.g. by
another team, another pipeline, or the [`secret-manager`](../secret-manager)
module in a separate root) and you only need to manage access.

The resources this module creates:

- `google_secret_manager_secret_iam_member` — one additive binding per entry
  in `accessors`

## Usage

```hcl
# Grant secretAccessor to a Cloud Run service identity
module "secret_access" {
  source = "./modules/secret-manager-iam"

  project_id = "my-project-id"
  secret_id  = "api-key"          # pre-existing secret
  accessors  = [
    "serviceAccount:backend@my-project-id.iam.gserviceaccount.com",
  ]
}

# Grant a custom role
module "secret_viewer" {
  source = "./modules/secret-manager-iam"

  project_id = "my-project-id"
  secret_id  = "db-password"
  role       = "roles/secretmanager.viewer"
  accessors  = ["group:ops@example.com"]
}
```

To create the secret and grant access in one call, use the
[`secret-manager`](../secret-manager) module instead.

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
| [google_secret_manager_secret_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID. | `string` | n/a | yes |
| <a name="input_secret_id"></a> [secret\_id](#input\_secret\_id) | ID of an existing Secret Manager secret (not necessarily TF-managed). | `string` | n/a | yes |
| <a name="input_accessors"></a> [accessors](#input\_accessors) | List of IAM members to grant the role. | `list(string)` | `[]` | no |
| <a name="input_role"></a> [role](#input\_role) | IAM role to grant. Defaults to secretAccessor. | `string` | `"roles/secretmanager.secretAccessor"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_members"></a> [members](#output\_members) | The IAM members granted the role. |
<!-- END_TF_DOCS -->
