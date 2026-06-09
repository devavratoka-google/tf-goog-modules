# network_attachments

Creates a [`google_compute_network_attachment`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_attachment) in your (consumer) VPC.

A network attachment is the primitive that lets a **producer** service create a PSC *interface* into your network. The main use case here is **Cloud SQL outbound connectivity (PSC interface)**: a PSC-enabled Cloud SQL instance attaches an interface to this network attachment so it can **initiate outbound connections** into your VPC (e.g. Database Migration Service reaching a source database).

This module only creates the network attachment. To wire it into a Cloud SQL instance, pass this module's `self_link` output to the instance's `ip_configuration.psc_network_attachment_uri`.

## Direction recap

| PSC concept | Direction | Module |
|---|---|---|
| Service attachment (`psc_enabled`) | inbound (clients reach the DB) | `cloud-sql-postgresql` |
| Consumer endpoint (IP + forwarding rule) | inbound | `pscendpoints` |
| **Network attachment + PSC interface** | **outbound (DB reaches your VPC)** | **this module** + `cloud-sql-postgresql` `psc_network_attachment_uri` |

## Outbound PSC limitations (Cloud SQL)

- Enabling/disabling outbound connectivity causes **downtime (~3 min)**.
- **Not** supported on read replicas, nor on instances that have a DR replica.
- **Incompatible** with instances using both private service access (PSA) and PSC simultaneously.
- If outbound is enabled, you **cannot create a replica** of that instance.
- DNS/hostname targets must resolve to RFC-1918 addresses.

## Example

```hcl
module "sql_outbound_na" {
  source = "./modules/network_attachments"

  name                  = "sql-outbound-na"
  project               = "my-consumer-project"
  region                = "us-east4"
  subnetworks           = ["projects/my-consumer-project/regions/us-east4/subnetworks/my-subnet"]
  connection_preference = "ACCEPT_MANUAL"
  producer_accept_lists = ["my-database-project"]
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the network attachment (RFC1035). | `string` | n/a | yes |
| project | Consumer project that owns the VPC/subnetwork. | `string` | n/a | yes |
| region | Region of the network attachment. | `string` | n/a | yes |
| subnetworks | Self-links of subnetworks the producer will use. | `list(string)` | n/a | yes |
| connection_preference | `ACCEPT_AUTOMATIC` or `ACCEPT_MANUAL`. | `string` | `"ACCEPT_AUTOMATIC"` | no |
| description | Optional description. | `string` | `null` | no |
| producer_accept_lists | Projects allowed (ACCEPT_MANUAL). | `list(string)` | `[]` | no |
| producer_reject_lists | Projects rejected. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the network attachment. |
| self_link | The URI to use as `network_attachment_uri`. |
| name | The name of the network attachment. |
<!-- END_TF_DOCS -->
