# terraform-google-firestore

> **Upstream source:** This module is a **verbatim copy** of
> [`GoogleCloudPlatform/terraform-google-firestore`](https://github.com/GoogleCloudPlatform/terraform-google-firestore)
> (published on the Terraform Registry as `GoogleCloudPlatform/firestore/google`).
> Do **not** modify the `.tf` files locally; sync from upstream instead to keep updates trivial:
>
> ```bash
> cp /path/to/terraform-google-firestore/{main,variables,outputs,versions}.tf \
>    ./modules/firestore/
> ```
>
> **Local divergences from upstream:**
> - `versions.tf`: `hashicorp/google` upper bound bumped from `< 7` to `< 8`. The rest of this repo requires `google >= 7.0.0`, so keeping the upstream constraint would make `terraform init` on the root impossible. Re-evaluate when upstream bumps the bound.

## Description
### Tagline
This terraform module is used to create a [Cloud Firestore](https://cloud.google.com/products/firestore) database

### Detailed
The resources/services/activations/deletions that this module will create/trigger are:

- Creates a Cloud Firestore database.
- Creates a daily/weekly backup schedule for the Firestore database.
- Creates composite indexes for the database.
- Creates single fields exempt from default indexing for the database.

## Usage
Basic usage of this module is as follows:

```hcl
module "firestore_infra" {
  source = "terraform-google-modules/firestore/google"
  project_id = "<PROJECT_ID>"
  database_id = "firestore-test-db"
  location_id = "us-central1"
  database_type = "FIRESTORE_NATIVE"
  concurrency_mode = "OPTIMISTIC"
  delete_protection_state = "DELETE_PROTECTION_DISABLED"
  point_in_time_recovery_enablement = "POINT_IN_TIME_RECOVERY_DISABLED"
  deletion_policy = "ABANDON"
  backup_schedule_configuration = {
    daily_recurrence = {}
    retention = "2419200s"
  }

  composite_index_configuration = [
    {
      index_id = "my-index1"
      collection = "terraform-firestore-collection"
      query_scope = "COLLECTION"
      api_scope = "ANY_API"
      fields = [
        {
          field_path = "field1"
          order = "ASCENDING"
        },
        {
          field_path = "field2"
          order = "DESCENDING"
        }
      ]
    }
  ]

  field_configuration = [
    {
      collection = "reviews"
      field = "field3"
      ascending_index_query_scope = ["COLLECTION_GROUP"]
      descending_index_query_scope = ["COLLECTION_GROUP"]
      array_index_query_scope = ["COLLECTION"]
    },
    {
      collection = "reviews"
      field = "field4"
      ascending_index_query_scope = ["COLLECTION_GROUP", "COLLECTION_GROUP"]
    }
  ]
}

```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
Copyright 2025 Google LLC

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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_firestore_backup_schedule.daily_backup_schedule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firestore_backup_schedule) | resource |
| [google_firestore_backup_schedule.weekly_backup_schedule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firestore_backup_schedule) | resource |
| [google_firestore_database.firestore_database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firestore_database) | resource |
| [google_firestore_field.firestore_field](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firestore_field) | resource |
| [google_firestore_index.firestore_index](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firestore_index) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_schedule_configuration"></a> [backup\_schedule\_configuration](#input\_backup\_schedule\_configuration) | Backup schedule configuration for the Firestore Database. | <pre>object({<br/>    weekly_recurrence = optional(object({<br/>      day       = string<br/>      retention = string<br/>    }))<br/><br/>    daily_recurrence = optional(object({<br/>      retention = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_composite_index_configuration"></a> [composite\_index\_configuration](#input\_composite\_index\_configuration) | Composite index configuration for the Firestore Database. | <pre>list(object({<br/>    index_id    = string<br/>    collection  = string<br/>    query_scope = optional(string, "COLLECTION")<br/>    api_scope   = optional(string, "ANY_API")<br/>    density     = optional(string)<br/>    multikey    = optional(bool)<br/>    fields = list(object({<br/>      field_path   = string<br/>      order        = optional(string)<br/>      array_config = optional(string)<br/>      vector_config = optional(object({<br/>        dimension = number<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_concurrency_mode"></a> [concurrency\_mode](#input\_concurrency\_mode) | Concurrency control mode to be used for the Firestore Database. | `string` | `"PESSIMISTIC"` | no |
| <a name="input_database_edition"></a> [database\_edition](#input\_database\_edition) | The database edition used to create the Firestore database. | `string` | `"STANDARD"` | no |
| <a name="input_database_id"></a> [database\_id](#input\_database\_id) | Unique identifier of the Firestore Database. | `string` | n/a | yes |
| <a name="input_database_type"></a> [database\_type](#input\_database\_type) | Database type used to created the Firestore Database. | `string` | `"FIRESTORE_NATIVE"` | no |
| <a name="input_delete_protection_state"></a> [delete\_protection\_state](#input\_delete\_protection\_state) | Determines whether deletion protection is enabled or not for the Firestore Database. | `string` | `"DELETE_PROTECTION_ENABLED"` | no |
| <a name="input_deletion_policy"></a> [deletion\_policy](#input\_deletion\_policy) | Deletion policy enforced when Firestore Database is destroyed via Terraform. | `string` | `"DELETE"` | no |
| <a name="input_field_configuration"></a> [field\_configuration](#input\_field\_configuration) | Single field configurations for the Firestore Database. | <pre>list(object({<br/>    collection                   = string<br/>    field                        = string<br/>    ttl_enabled                  = optional(bool, false)<br/>    ascending_index_query_scope  = optional(set(string), [])<br/>    descending_index_query_scope = optional(set(string), [])<br/>    array_index_query_scope      = optional(set(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | The resource ID of the Customer-managed Encryption Key (CMEK) using which the created database will be encrypted. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location in which the Firesotre Database is created. | `string` | n/a | yes |
| <a name="input_point_in_time_recovery_enablement"></a> [point\_in\_time\_recovery\_enablement](#input\_point\_in\_time\_recovery\_enablement) | Determines whether point-in-time recovery is enabled for the Firestore Database. | `string` | `"POINT_IN_TIME_RECOVERY_ENABLED"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the Firestore resources are created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_composite_index_ids"></a> [composite\_index\_ids](#output\_composite\_index\_ids) | List of composite indices for the firestore database. |
| <a name="output_daily_backup_schedule_id"></a> [daily\_backup\_schedule\_id](#output\_daily\_backup\_schedule\_id) | The unique backup schedule identifier across all locations and databases for the given project. |
| <a name="output_database_id"></a> [database\_id](#output\_database\_id) | The full database resource name of the firestore database, in the format projects/{{project\_id}}/databases/{{name}} |
| <a name="output_database_resource_id"></a> [database\_resource\_id](#output\_database\_resource\_id) | The database id of the firestore database. |
| <a name="output_field_ids"></a> [field\_ids](#output\_field\_ids) | List of firestore fields created for the database. |
| <a name="output_weekly_backup_schedule_id"></a> [weekly\_backup\_schedule\_id](#output\_weekly\_backup\_schedule\_id) | The unique backup schedule identifier across all locations and databases for the given project. |
<!-- END_TF_DOCS -->
