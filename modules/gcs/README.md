# Terraform Google Cloud Storage Module

> **Upstream source:** This module is a near-verbatim copy of
> [`terraform-google-modules/terraform-google-cloud-storage` → `modules/simple_bucket`](https://github.com/terraform-google-modules/terraform-google-cloud-storage/tree/master/modules/simple_bucket).
>
> **Single local divergence** (`main.tf`, block `module "encryption_key"`):
> `source` repointed from `"terraform-google-modules/kms/google"` to `"../kms"` (and the `version`
> argument removed, since it is not valid for local sources). The `../kms` module is a verbatim copy
> of [`terraform-google-modules/terraform-google-kms`](https://github.com/terraform-google-modules/terraform-google-kms).
> This avoids transitive Terraform Registry dependencies and keeps the module self-contained.
>
> Sync from upstream:
>
> ```bash
> cp /path/to/terraform-google-cloud-storage/modules/simple_bucket/{main,variables,outputs,versions}.tf \
>    ./modules/gcs/
> # Then reapply the single local change in main.tf:
> #   source = "../kms"   (drop the version = "~> 4.0" line)
> ```

This module makes it easy to create a GCS bucket, and assign basic permissions on it to arbitrary users.

The resources/services/activations/deletions that this module will create/trigger are:

- One GCS bucket
- Zero or more IAM bindings for that bucket

## Compatibility

This module is meant for use with Terraform 0.13+.

## Usage

Basic usage of this module is as follows:

```hcl
module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 12.3"

  name       = "example-bucket"
  project_id = "example-project"
  location   = "us-east1"
  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "user:example-user@example.com"
  }]
}
```

Functional examples are included in the
[examples](../../examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
Copyright 2020 Google LLC

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_encryption_key"></a> [encryption\_key](#module\_encryption\_key) | ../kms | n/a |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.members](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_project_service_account.gcs_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_project_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoclass"></a> [autoclass](#input\_autoclass) | While set to true, autoclass is enabled for this bucket. | `bool` | `false` | no |
| <a name="input_bucket_policy_only"></a> [bucket\_policy\_only](#input\_bucket\_policy\_only) | Enables Bucket Policy Only access to a bucket. | `bool` | `true` | no |
| <a name="input_cors"></a> [cors](#input\_cors) | Configuration of CORS for bucket with structure as defined in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#cors. | <pre>list(object({<br/>    origin          = optional(list(string))<br/>    method          = optional(list(string))<br/>    response_header = optional(list(string))<br/>    max_age_seconds = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_custom_placement_config"></a> [custom\_placement\_config](#input\_custom\_placement\_config) | Configuration of the bucket's custom location in a dual-region bucket setup. If the bucket is designated a single or multi-region, the variable are null. | <pre>object({<br/>    data_locations = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | A Cloud KMS key that will be used to encrypt objects inserted into this bucket. The key name should follow the format of `projects/<project-name>/locations/<location-name>/keyRings/<keyring-name>/cryptoKeys/<key-name>`. To use a Cloud KMS key automatically created by this module use the `internal_encryption_config` input variable. | <pre>object({<br/>    default_kms_key_name = string<br/>  })</pre> | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects. | `bool` | `false` | no |
| <a name="input_hierarchical_namespace"></a> [hierarchical\_namespace](#input\_hierarchical\_namespace) | When set to true, hierarchical namespace is enable for this bucket. | `bool` | `false` | no |
| <a name="input_iam_members"></a> [iam\_members](#input\_iam\_members) | The list of IAM members to grant permissions on the bucket. | <pre>list(object({<br/>    role   = string<br/>    member = string<br/>  }))</pre> | `[]` | no |
| <a name="input_internal_encryption_config"></a> [internal\_encryption\_config](#input\_internal\_encryption\_config) | Configuration for the creation of an internal Google Cloud Key Management Service (KMS) Key for use as Customer-managed encryption key (CMEK) for the GCS Bucket<br/>  instead of creating one in advance and providing the key in the variable `encryption.default_kms_key_name`.<br/>  create\_encryption\_key: If `true` a Google Cloud Key Management Service (KMS) KeyRing and a Key will be created<br/>  prevent\_destroy: Set the prevent\_destroy lifecycle attribute on keys.<br/>  key\_destroy\_scheduled\_duration: Set the period of time that versions of keys spend in the `DESTROY_SCHEDULED` state before transitioning to `DESTROYED`.<br/>  key\_rotation\_period: Generate a new key every time this period passes. | <pre>object({<br/>    create_encryption_key          = optional(bool, false)<br/>    prevent_destroy                = optional(bool, false)<br/>    key_destroy_scheduled_duration = optional(string, null)<br/>    key_rotation_period            = optional(string, "7776000s")<br/>  })</pre> | `{}` | no |
| <a name="input_ip_filter"></a> [ip\_filter](#input\_ip\_filter) | The IP filter configuration for the bucket. Restricts access based on source IP addresses.<br/><br/>- mode: "Enabled" or "Disabled"<br/>- public\_network\_source: (Optional) Configure allowed public internet IP ranges<br/>- vpc\_network\_sources: (Optional) Configure allowed VPC networks and IP ranges<br/>- allow\_cross\_org\_vpcs: (Optional) Allow VPC networks from different organizations<br/>- allow\_all\_service\_agent\_access: (Optional) Allow Google Cloud service agents to access the bucket regardless of IP filtering<br/><br/>Both public\_network\_source and vpc\_network\_sources can be configured together.<br/><br/>Example:<pre>ip_filter = {<br/>  mode = "Enabled"<br/>  public_network_source = {<br/>    allowed_ip_cidr_ranges = ["203.0.113.0/24"]<br/>  }<br/>  vpc_network_sources = [{<br/>    network = "projects/my-project/global/networks/my-vpc"<br/>    allowed_ip_cidr_ranges = ["10.0.0.0/8"]<br/>  }]<br/>  allow_cross_org_vpcs = true<br/>  allow_all_service_agent_access = true<br/>}</pre>Limits: Max 200 IP CIDR blocks, 25 VPC networks. May block some Google Cloud services.<br/>See https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#ip_filter-1 | <pre>object({<br/>    mode = string<br/>    public_network_source = optional(object({<br/>      allowed_ip_cidr_ranges = list(string)<br/>    }))<br/>    vpc_network_sources = optional(list(object({<br/>      network                = string<br/>      allowed_ip_cidr_ranges = list(string)<br/>    })))<br/>    allow_cross_org_vpcs           = optional(bool)<br/>    allow_all_service_agent_access = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of key/value label pairs to assign to the bucket. | `map(string)` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | The bucket's Lifecycle Rules configuration. | <pre>list(object({<br/>    # Object with keys:<br/>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br/>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br/>    action = object({<br/>      type          = string<br/>      storage_class = optional(string)<br/>    })<br/><br/>    # Object with keys:<br/>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br/>    # - send_age_if_zero - (Optional) While set true, num_newer_versions value will be sent in the request even for zero value of the field.<br/>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br/>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br/>    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br/>    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.<br/>    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition<br/>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br/>    # - custom_time_before - (Optional) A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.<br/>    # - days_since_custom_time - (Optional) Days since the date set in the customTime metadata for the object.<br/>    # - days_since_noncurrent_time - (Optional) Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object.<br/>    # - noncurrent_time_before - (Optional) Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent.<br/>    condition = object({<br/>      age                        = optional(number)<br/>      send_age_if_zero           = optional(bool)<br/>      created_before             = optional(string)<br/>      with_state                 = optional(string)<br/>      matches_storage_class      = optional(string)<br/>      matches_prefix             = optional(string)<br/>      matches_suffix             = optional(string)<br/>      num_newer_versions         = optional(number)<br/>      custom_time_before         = optional(string)<br/>      days_since_custom_time     = optional(number)<br/>      days_since_noncurrent_time = optional(number)<br/>      noncurrent_time_before     = optional(string)<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the bucket. See https://cloud.google.com/storage/docs/locations. | `string` | n/a | yes |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | The bucket that will receive log objects. | `string` | `null` | no |
| <a name="input_log_object_prefix"></a> [log\_object\_prefix](#input\_log\_object\_prefix) | The object prefix for log objects. If it's not provided, by default GCS sets this to this bucket's name | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the bucket. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project to create the bucket in. | `string` | n/a | yes |
| <a name="input_public_access_prevention"></a> [public\_access\_prevention](#input\_public\_access\_prevention) | Prevents public access to a bucket. Acceptable values are inherited or enforced. If inherited, the bucket uses public access prevention, only if the bucket is subject to the public access prevention organization policy constraint. | `string` | `"inherited"` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. | <pre>object({<br/>    is_locked        = optional(bool)<br/>    retention_period = number<br/>  })</pre> | `null` | no |
| <a name="input_soft_delete_policy"></a> [soft\_delete\_policy](#input\_soft\_delete\_policy) | Soft delete policies to apply. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#nested_soft_delete_policy | <pre>object({<br/>    retention_duration_seconds = optional(number)<br/>  })</pre> | `{}` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | The Storage Class of the new bucket. | `string` | `null` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | While set to true, versioning is fully enabled for this bucket. | `bool` | `true` | no |
| <a name="input_website"></a> [website](#input\_website) | Map of website values. Supported attributes: main\_page\_suffix, not\_found\_page | <pre>object({<br/>    main_page_suffix = optional(string)<br/>    not_found_page   = optional(string)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apphub_service_uri"></a> [apphub\_service\_uri](#output\_apphub\_service\_uri) | URI in CAIS style to be used by Apphub. |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The created storage bucket |
| <a name="output_internal_kms_configuration"></a> [internal\_kms\_configuration](#output\_internal\_kms\_configuration) | The intenal KMS Resource. |
| <a name="output_name"></a> [name](#output\_name) | Bucket name. |
| <a name="output_url"></a> [url](#output\_url) | Bucket URL. |
<!-- END_TF_DOCS -->
