# Next-Generation Firewall (NGFW) Endpoint Module

This module configures a Google Cloud Network Security Firewall Endpoint and its associated Network Security Firewall Endpoint Association resources.

## Usage

```hcl
module "ngfw_endpoint" {
  source             = "./modules/ngfw_endpoint"
  name               = "my-firewall-endpoint"
  parent             = "organizations/1234567890"
  location           = "us-central1-a"
  billing_project_id = "my-billing-project-id"
  labels             = { env = "production" }

  fw_ep_associations = {
    "assoc-1" = {
      fw_ip_association_parent   = "projects/my-vpc-project-id"
      network                    = "my-vpc-self-link"
      fw_ip_association_location = "us-central1-a"
      fw_ep_association_labels   = { env = "production" }
      tls_inspection_policy      = "projects/my-vpc-project-id/locations/us-central1-a/tlsInspectionPolicies/my-tls-policy"
      disabled                   = false
    }
  }
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
| name | The name of the firewall endpoint resource. | `string` | n/a | yes |
| parent | The name of the parent this firewall endpoint belongs to. Format: `organizations/{organization_id}`. | `string` | n/a | yes |
| location | The location (zone) of the firewall endpoint. | `string` | n/a | yes |
| billing_project_id | Project to bill on endpoint uptime usage. | `string` | n/a | yes |
| labels | A map of key/value label pairs to assign to the resource. | `map(string)` | n/a | yes |
| fw_ep_associations | A map of firewall endpoint association definitions. | <pre>map(object({<br>  fw_ip_association_parent   = string<br>  network                    = string<br>  fw_ip_association_location = string<br>  fw_ep_association_labels   = map(string)<br>  tls_inspection_policy      = string<br>  disabled                   = bool<br>}))</pre> | n/a | yes |

## Outputs

This module does not define any outputs.
