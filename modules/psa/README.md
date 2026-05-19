# Private Service Access (PSA) Module

This module creates a GCP Service Networking Connection to enable Private Service Access (PSA) with Google service producers, and configures the connection to import and export custom routes.

## Usage

```hcl
module "private_service_access" {
  source                  = "./modules/psa"
  network                 = "my-vpc-self-link"
  reserved_peering_ranges = ["my-reserved-peering-range-name"]
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
| network | The VPC network URL/Self Link connected with service producers. | `string` | n/a | yes |
| reserved_peering_ranges | List of named IP address range(s) of PEERING type reserved for the service provider. | `list(string)` | n/a | yes |

## Outputs

This module does not define any outputs.
