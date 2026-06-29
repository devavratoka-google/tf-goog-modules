# Projects Data Module

This module queries Google Cloud projects using filters. It supports optional filtering by a parent folder ID.

## Usage

```hcl
module "projects" {
  source           = "./modules/projects"
  parent_folder_id = "1234567890"
}
```

<!-- BEGIN_TF_DOCS -->
Copyright 2026 Google LLC

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

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_asset_resources_search.recursive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/cloud_asset_resources_search) | data source |
| [google_projects.non_recursive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/projects) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parent_folder_id"></a> [parent\_folder\_id](#input\_parent\_folder\_id) | The ID of the parent folder to search projects under (e.g., '1234567890'). | `string` | `"581347979992"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_ids"></a> [project\_ids](#output\_project\_ids) | List of active project IDs retrieved. |
| <a name="output_projects"></a> [projects](#output\_projects) | List of active projects retrieved. |
<!-- END_TF_DOCS -->
