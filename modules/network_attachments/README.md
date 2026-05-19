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
| name | Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. | `string` | n/a | yes |
| region | URL of the region where the network attachment resides. | `string` | n/a | yes |
| description | An optional description of this resource. | `string` | n/a | yes |
| connection_preference | The connection preference of the service attachment. Possible values: `ACCEPT_AUTOMATIC`, `ACCEPT_MANUAL`, `INVALID`. | `string` | n/a | yes |
| subnetworks | An array of URLs where each entry is the URL of a subnet provided by the service consumer. | `list(string)` | n/a | yes |
| producer_accept_lists | Projects that are allowed to connect to this network attachment (by ID or number). | `list(string)` | n/a | yes |
| producer_reject_lists | Projects that are not allowed to connect to this network attachment (by ID or number). | `list(string)` | n/a | yes |
| project | The ID of the project in which the resource belongs. | `string` | `"The ID of the project..."` | no |

## Outputs

This module does not define any outputs.
