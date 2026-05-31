# Network Attachments Module

This module creates a Google Cloud Compute Network Attachment, which allows a producer VPC network to initiate connections to a consumer VPC network.

## Usage

```hcl
module "network_attachment" {
  source                = "./modules/network_attachments"
  name                  = "my-network-attachment"
  region                = "us-central1"
  project               = "my-project-id"
  description           = "My network attachment for Private Service Connect"
  connection_preference = "ACCEPT_AUTOMATIC"
  subnetworks           = ["my-subnet-self-link"]
  producer_accept_lists = ["consumer-project-id"]
  producer_reject_lists = []
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
| [google_compute_network_attachment.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connection_preference"></a> [connection\_preference](#input\_connection\_preference) | The connection preference of service attachment. The value can be set to ACCEPT\_AUTOMATIC. An ACCEPT\_AUTOMATIC service attachment is one that always accepts the connection from consumer forwarding rules. Possible values are: ACCEPT\_AUTOMATIC, ACCEPT\_MANUAL, INVALID. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. Provide this property when you create the resource. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. | `string` | n/a | yes |
| <a name="input_producer_accept_lists"></a> [producer\_accept\_lists](#input\_producer\_accept\_lists) | Projects that are allowed to connect to this network attachment. The project can be specified using its id or number. | `list(string)` | n/a | yes |
| <a name="input_producer_reject_lists"></a> [producer\_reject\_lists](#input\_producer\_reject\_lists) | Projects that are not allowed to connect to this network attachment. The project can be specified using its id or number. | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"The ID of the project in which the resource belongs. If it is not provided, the provider project is used."` | no |
| <a name="input_region"></a> [region](#input\_region) | URL of the region where the network attachment resides. This field applies only to the region resource. | `string` | n/a | yes |
| <a name="input_subnetworks"></a> [subnetworks](#input\_subnetworks) | An array of URLs where each entry is the URL of a subnet provided by the service consumer to use for endpoints in the producers that connect to this network attachment. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created network attachment. |
| <a name="output_name"></a> [name](#output\_name) | The name of the created network attachment. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the created network attachment. |
<!-- END_TF_DOCS -->
