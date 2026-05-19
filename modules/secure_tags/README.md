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

## Requirements

| Name | Version |
|------|---------|
| terraform | > 1.5.0 |
| google | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| parent | The resource name of the new TagKey's parent (e.g. `organizations/{org_id}` or `projects/{project_id}`). | `string` | n/a | yes |
| purpose_data | Purpose data (corresponds to the policy system, e.g. `{"network" = "project-id/vpc-name"}`). | `map(string)` | n/a | yes |
| short_name | The user-friendly name for the TagKey. | `string` | n/a | yes |
| description | User-assigned description of the TagKey. | `string` | n/a | yes |
| tag_values | A map of tag values to create. The key is the short name prefix, and the value is the tag value properties. | <pre>map(object({<br>  tagvalue_short_name  = string<br>  tagvalue_description = string<br>}))</pre> | n/a | yes |
| iam_viewer_members | Members that will have viewer permissions (`roles/resourcemanager.tagViewer`) to the tag and values. | `list(string)` | n/a | yes |
| iam_user_members | Members that will have user permissions (`roles/resourcemanager.tagUser`) to the tag and values. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| tagkey | The resource ID of the created Tag Key |
| tagvalue | Map of the tag value keys to their corresponding Tag Value IDs |
