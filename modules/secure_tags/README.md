# Secure Tags Module

This module creates a Google Cloud resource Tag Key (specifically configured for `GCE_FIREWALL` purposes) and multiple associated Tag Values. It also configures IAM bindings for Tag Viewer and Tag User roles on both the Tag Key and Tag Values.

## Usage

```hcl
module "secure_tags" {
  source       = "./modules/secure_tags"
  parent       = "organizations/1234567890"
  short_name   = "environment"
  description  = "Tag key for environments"
  purpose_data = {
    network = "my-project-id/my-vpc"
  }

  tag_values = {
    "prod" = {
      tagvalue_short_name  = "production"
      tagvalue_description = "Production environment"
    }
    "nonprod" = {
      tagvalue_short_name  = "non-production"
      tagvalue_description = "Non-production environment"
    }
  }

  iam_viewer_members = ["group:auditors@example.com"]
  iam_user_members   = ["serviceAccount:deployer@my-project-id.iam.gserviceaccount.com"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.0.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_tags_tag_key.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_key) | resource |
| [google_tags_tag_key_iam_binding.user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_key_iam_binding) | resource |
| [google_tags_tag_key_iam_binding.viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_key_iam_binding) | resource |
| [google_tags_tag_value.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_value) | resource |
| [google_tags_tag_value_iam_binding.user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_value_iam_binding) | resource |
| [google_tags_tag_value_iam_binding.viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_tag_value_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | User-assigned description of the TagKey. Must not exceed 256 characters. | `string` | n/a | yes |
| <a name="input_iam_user_members"></a> [iam\_user\_members](#input\_iam\_user\_members) | Members that will have user permissions to this tag/value | `list(string)` | n/a | yes |
| <a name="input_iam_viewer_members"></a> [iam\_viewer\_members](#input\_iam\_viewer\_members) | Members that will have viewer permissions to this tag/value | `list(string)` | n/a | yes |
| <a name="input_parent"></a> [parent](#input\_parent) | The resource name of the new TagKey's parent. Must be of the form organizations/{org\_id} or projects/{project\_id\_or\_number}. | `string` | n/a | yes |
| <a name="input_purpose_data"></a> [purpose\_data](#input\_purpose\_data) | Purpose data cannot be changed once set. Purpose data corresponds to the policy system that the tag is intended for. For example, the GCE\_FIREWALL purpose expects data in the following format: 'network = '/''. | `map(string)` | n/a | yes |
| <a name="input_short_name"></a> [short\_name](#input\_short\_name) | (Required) Input only. The user friendly name for a TagKey. The short name should be unique for TagKeys within the same tag namespace. The short name must be 1-63 characters, beginning and ending with an alphanumeric character ([a-z0-9A-Z]) with dashes (-), underscores (\_), dots (.), and alphanumerics between. | `string` | n/a | yes |
| <a name="input_tag_values"></a> [tag\_values](#input\_tag\_values) | A map of tag values to create. The key is the short name of the tag value, and the value is a map of the tag value properties. | <pre>map(object({<br/>    tagvalue_short_name  = string // Input only. User-assigned short name for TagValue. The short name should be unique for TagValues within the same parent TagKey. The short name must be 63 characters or less, beginning and ending with an alphanumeric character ([a-z0-9A-Z]) with dashes (-), underscores (_), dots (.), and alphanumerics between.<br/>    tagvalue_description = string // User-assigned description of the TagValue. Must not exceed 256 characters.<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tagkey"></a> [tagkey](#output\_tagkey) | n/a |
| <a name="output_tagvalue"></a> [tagvalue](#output\_tagvalue) | n/a |
<!-- END_TF_DOCS -->
