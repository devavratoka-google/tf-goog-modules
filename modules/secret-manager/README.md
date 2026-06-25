# Secret Manager Module

This module manages a Secret Manager secret and optional IAM accessors.

## Usage

```hcl
module "secret" {
  source     = "./modules/secret-manager"
  project_id = "my-project-id"
  secret_id  = "my-secret-id"
  accessors  = ["serviceAccount:my-sa@my-project-id.iam.gserviceaccount.com"]
}
```

<!-- BEGIN_TF_DOCS -->
Copyright 2021 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

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
| [google_secret_manager_secret.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.accessors](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accessors"></a> [accessors](#input\_accessors) | List of IAM members to grant roles/secretmanager.secretAccessor. | `list(string)` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_replication"></a> [replication](#input\_replication) | Replication policy. Defaults to automatic. | <pre>object({<br/>    auto         = optional(bool, true)<br/>    user_managed = optional(list(object({ location = string })), [])<br/>  })</pre> | <pre>{<br/>  "auto": true<br/>}</pre> | no |
| <a name="input_secret_id"></a> [secret\_id](#input\_secret\_id) | ID for the secret. Must be unique within the project. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | n/a |
<!-- END_TF_DOCS -->
