# PSC Endpoints Module

This module manages Google Cloud Private Service Connect (PSC) resources.

## Features

- **Address Only**: Always creates an internal IP address reserved for PSC (`purpose = "GCE_ENDPOINT"`).
- **Google APIs Regional Endpoint**: Creates a regional endpoint for Google APIs when `target_google_api` is provided and `access_type` is set to `REGIONAL`.
- **Google APIs Global Endpoint**: Creates a global endpoint for Google APIs when `target_google_api` is provided and `access_type` is set to `GLOBAL`. It supports passing the address as a self-link.
- **Consumer Forwarding Rule**: Creates a forwarding rule pointing to a published service (Service Attachment) when `target_service_attachment` is provided.
- **Producer Service Attachment**: Creates a service attachment to publish a service when the `service_attachment` object is provided.



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project` | The project ID to deploy resources in. | `string` | n/a | yes |
| `network` | The self-link of the network. | `string` | n/a | yes |
| `subnetwork` | The self-link of the subnetwork. | `string` | n/a | yes |
| `region` | The region to deploy resources in. | `string` | n/a | yes |
| `address_name` | Name of the compute address. | `string` | n/a | yes |
| `address` | The IP address to reserve. If null, one will be automatically allocated. | `string` | `null` | no |
| `target_google_api` | The target Google API for the regional/global endpoint. | `string` | `null` | no |
| `access_type` | Access type for the network connectivity endpoint. Can be REGIONAL or GLOBAL. | `string` | `"REGIONAL"` | no |
| `regional_endpoint_subnetwork` | Set to true for global endpoint to use subnetwork. | `bool` | `false` | no |
| `regional_endpoint_address_use_self_link` | Set to true to use self link for address in global endpoint. | `bool` | `false` | no |
| `target_service_attachment` | The target service attachment for the consumer forwarding rule. | `string` | `null` | no |
| `allow_psc_global_access` | Allow global access for PSC forwarding rule. | `bool` | `false` | no |
| `no_automate_dns_zone` | Disable automatic DNS zone creation for PSC forwarding rule. | `bool` | `false` | no |
| `forwarding_rule_name` | Name of the forwarding rule. | `string` | `null` | no |
| `service_attachment` | Configuration for the producer service attachment. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `address` | The IP address reserved. |
| `address_name` | The name of the address. |
| `address_self_link` | The self-link of the address. |
| `regional_endpoint_name` | The name of the regional endpoint. |
| `regional_endpoint_id` | The ID of the regional endpoint. |
| `psc_forwarding_rule` | The full forwarding rule resource for consumer PSC. |
| `target_google_api` | The target Google API. |
| `consumer_forwarding_rule_name` | The name of the consumer forwarding rule. |
| `consumer_forwarding_rule_self_link` | The self-link of the consumer forwarding rule. |
| `consumer_psc_connection_id` | The PSC connection ID of the consumer forwarding rule. |
| `consumer_psc_connection_status` | The PSC connection status of the consumer forwarding rule. |
| `service_attachment_name` | The name of the service attachment. |
| `service_attachment_self_link` | The self-link of the service attachment. |

