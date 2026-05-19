# Global Addresses Module

This module creates a Google Cloud Compute Global Address.

## Usage

```hcl
module "global_addresses" {
  source      = "./modules/global_addresses"
  name        = "my-global-address"
  description = "My global address for VPC peering"
  labels      = { environment = "production" }
  ip_version  = "IPV4"
  project     = "my-project-id"
  network     = "my-vpc-self-link"
  address     = "10.0.0.0"
  prefix_length = 16
  purpose     = "VPC_PEERING"
  address_type = "INTERNAL"
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
| description | An optional description of this resource. | `string` | n/a | yes |
| labels | Labels | `map(string)` | n/a | yes |
| ip_version | The IP Version that will be used by this address. The default value is IPV4. Possible values are: IPV4, IPV6. | `string` | n/a | yes |
| project | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| network | The URL of the network in which to reserve the IP range. The IP range must be in RFC1918 space. The network cannot be deleted if there are any reserved IP ranges referring to it. This should only be set when using an Internal address. | `string` | n/a | yes |
| address | The IP address or beginning of the address range represented by this resource. This can be supplied as an input to reserve a specific address or omitted to allow GCP to choose a valid one for you. | `string` | n/a | yes |
| prefix_length | The prefix length of the IP range. If not present, it means the address field is a single IP address. This field is not applicable to addresses with addressType=INTERNAL when purpose=PRIVATE_SERVICE_CONNECT | `number` | n/a | yes |
| purpose | The purpose of the resource. Possible values include: VPC_PEERING or PRIVATE_SERVICE_CONNECT | `string` | n/a | yes |
| address_type | The type of the address to reserve. Default value is EXTERNAL. Possible values are: EXTERNAL, INTERNAL. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| global_address_name | The IP address reserved |
