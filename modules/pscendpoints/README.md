# PSC Endpoints Module

This module creates Google Cloud Private Service Connect (PSC) resources for three main paths:

- Consume Google APIs through PSC (regional or global).
- Consume a Service Attachment published by another service.
- Publish your own service through a Service Attachment (producer).

## How The Code Works (Block By Block)

1. `module "addresses"` in `main.tf`
- Creates a regional internal IP when `create_regional_address = true`.
- Uses `purpose = "GCE_ENDPOINT"`.
- Typically used in the regional endpoint path.

2. `google_compute_global_address.this` in `main.tf`
- Creates a global internal IP when `create_global_address = true`.
- Uses `purpose = "PRIVATE_SERVICE_CONNECT"`.
- Required for global scenarios (`all-apis` and `vpc-sc`).

3. `google_network_connectivity_regional_endpoint.this` in `main.tf`
- Creates a regional endpoint for a Google API when `target_google_api` is set and is not `all-apis` or `vpc-sc`.
- Example: `storage.us-central1.rep.googleapis.com`.

4. `google_compute_global_forwarding_rule.google_apis` in `main.tf`
- Creates a global forwarding rule when `target_google_api = "all-apis"`.
- Uses the created global IP (or the IP provided in `address`).

5. `google_compute_global_forwarding_rule.vpc_sc` in `main.tf`
- Creates a global forwarding rule when `target_google_api = "vpc-sc"`.
- Uses the created global IP (or the IP provided in `address`).

6. `google_compute_forwarding_rule.this` in `main.tf`
- Creates a regional forwarding rule to consume `target_service_attachment`.
- This path is not for Google APIs. It is for PSC consumer service attachments.

7. `google_compute_service_attachment.this` in `main.tf`
- Creates a Service Attachment (producer) when `service_attachment` is set.
- Publishes a service to be consumed via PSC.

## Module Decision Rules

| Scenario | Main keys | Created resource |
|---|---|---|
| Google APIs regional | `target_google_api = "<api-regional>"` | `google_network_connectivity_regional_endpoint.this` |
| Google APIs global (private.googleapis.com) | `target_google_api = "all-apis"` | `google_compute_global_forwarding_rule.google_apis` |
| Google APIs global (restricted.googleapis.com / VPC-SC) | `target_google_api = "vpc-sc"` | `google_compute_global_forwarding_rule.vpc_sc` |
| Service attachment consumer | `target_service_attachment` set | `google_compute_forwarding_rule.this` |
| Service attachment producer | `service_attachment` set | `google_compute_service_attachment.this` |

## Where To Change Values To Build Resources In GCP

1. In the root layer, edit the `pscendpoints` map in your environment file.
- Typical example: `env.tfvars`.
- Each map item creates one module instance (`for_each`).

2. Minimum fields you should set for each item:
- `project`: project where resources will be created.
- `network_name`: target VPC.
- `region`: required for regional resources and kept as part of the object convention.
- `address`: desired internal IP (or use automatic allocation with `null`).
- `create_global_address` or `create_regional_address`: defines who creates the IP.

3. Field that defines the Google APIs endpoint type:
- `target_google_api = "all-apis"` for private.googleapis.com.
- `target_google_api = "vpc-sc"` for restricted.googleapis.com.
- `target_google_api = "<api-regional>"` for a specific regional endpoint.

4. Forwarding rule name:
- Use `forwarding_rule_name` for an explicit name.
- If omitted, the module uses `<address_name>-fr`.

## Practical Examples

### 1) Google APIs global - all-apis

```hcl
pscendpoints = {
	"psc-allapis" = {
		project               = "infra-proj-id"
		network_name          = "tf-vpc-01"
		region                = "us-central1"
		address               = "192.168.104.12"
		create_global_address = true
		target_google_api     = "all-apis"
		access_type           = "GLOBAL"
		forwarding_rule_name  = "pscallapis"
	}
}
```

### 2) Google APIs global - vpc-sc

```hcl
pscendpoints = {
	"psc-vpc-sc" = {
		project               = "infra-proj-id"
		network_name          = "tf-vpc-01"
		region                = "us-central1"
		address               = "192.168.104.11"
		create_global_address = true
		target_google_api     = "vpc-sc"
		access_type           = "GLOBAL"
		forwarding_rule_name  = "pscvpcsc"
	}
}
```

## Important Outputs

- `address` and `address_self_link`: effective reserved IP.
- `psc_forwarding_rule`: created forwarding rule resource (regional or global).
- `consumer_forwarding_rule_name` and `consumer_forwarding_rule_self_link`: reference to the created endpoint.
- `regional_endpoint_name` and `regional_endpoint_id`: populated when the regional path is used.
- `service_attachment_name` and `service_attachment_self_link`: populated when the producer path is used.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_addresses"></a> [addresses](#module\_addresses) | ../addresses | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_forwarding_rule.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_global_address.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.google_apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.vpc_sc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_service_attachment.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_service_attachment) | resource |
| [google_network_connectivity_regional_endpoint.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_regional_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_type"></a> [access\_type](#input\_access\_type) | Access type for the network connectivity endpoint. Can be REGIONAL or GLOBAL. | `string` | `"REGIONAL"` | no |
| <a name="input_address"></a> [address](#input\_address) | The IP address to reserve. If null, one will be automatically allocated. | `string` | `null` | no |
| <a name="input_address_name"></a> [address\_name](#input\_address\_name) | Name of the compute address. | `string` | n/a | yes |
| <a name="input_allow_psc_global_access"></a> [allow\_psc\_global\_access](#input\_allow\_psc\_global\_access) | Allow global access for PSC forwarding rule. | `bool` | `false` | no |
| <a name="input_create_global_address"></a> [create\_global\_address](#input\_create\_global\_address) | Set to true to create global compute address using the global\_addresses module. | `bool` | `false` | no |
| <a name="input_create_regional_address"></a> [create\_regional\_address](#input\_create\_regional\_address) | Set to true to create regional compute address using the addresses module. | `bool` | `false` | no |
| <a name="input_forwarding_rule_name"></a> [forwarding\_rule\_name](#input\_forwarding\_rule\_name) | Name of the forwarding rule. | `string` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | The self-link of the network. | `string` | n/a | yes |
| <a name="input_no_automate_dns_zone"></a> [no\_automate\_dns\_zone](#input\_no\_automate\_dns\_zone) | Disable automatic DNS zone creation for PSC forwarding rule. | `bool` | `false` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID to deploy resources in. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to deploy resources in. | `string` | n/a | yes |
| <a name="input_regional_endpoint_address_use_self_link"></a> [regional\_endpoint\_address\_use\_self\_link](#input\_regional\_endpoint\_address\_use\_self\_link) | Set to true to use self link for address in global endpoint. | `bool` | `false` | no |
| <a name="input_regional_endpoint_subnetwork"></a> [regional\_endpoint\_subnetwork](#input\_regional\_endpoint\_subnetwork) | Set to true for global endpoint to use subnetwork. | `bool` | `false` | no |
| <a name="input_service_attachment"></a> [service\_attachment](#input\_service\_attachment) | Configuration for the producer service attachment. | <pre>object({<br/>    name                  = string<br/>    description           = optional(string)<br/>    target_service        = string<br/>    nat_subnets           = list(string)<br/>    connection_preference = string<br/>    enable_proxy_protocol = optional(bool, false)<br/>    reconcile_connections = optional(bool, false)<br/>    domain_names          = optional(list(string), [])<br/>    consumer_reject_lists = optional(list(string), [])<br/>    consumer_accept_lists = optional(list(object({<br/>      project_id_or_num = string<br/>      connection_limit  = number<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_service_directory_registrations"></a> [service\_directory\_registrations](#input\_service\_directory\_registrations) | Service Directory registration configuration. | <pre>object({<br/>    namespace                = string<br/>    service                  = optional(string, null)<br/>    service_directory_region = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The self-link of the subnetwork. | `string` | `null` | no |
| <a name="input_target_google_api"></a> [target\_google\_api](#input\_target\_google\_api) | The target Google API for the regional/global endpoint (e.g., storage.us-central1.rep.googleapis.com). | `string` | `null` | no |
| <a name="input_target_service_attachment"></a> [target\_service\_attachment](#input\_target\_service\_attachment) | The target service attachment for the consumer forwarding rule. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | The IP address reserved. |
| <a name="output_address_name"></a> [address\_name](#output\_address\_name) | The name of the address. |
| <a name="output_address_self_link"></a> [address\_self\_link](#output\_address\_self\_link) | The self-link of the address. |
| <a name="output_consumer_forwarding_rule_name"></a> [consumer\_forwarding\_rule\_name](#output\_consumer\_forwarding\_rule\_name) | The name of the consumer forwarding rule. |
| <a name="output_consumer_forwarding_rule_self_link"></a> [consumer\_forwarding\_rule\_self\_link](#output\_consumer\_forwarding\_rule\_self\_link) | The self-link of the consumer forwarding rule. |
| <a name="output_consumer_psc_connection_id"></a> [consumer\_psc\_connection\_id](#output\_consumer\_psc\_connection\_id) | The PSC connection ID of the consumer forwarding rule. |
| <a name="output_consumer_psc_connection_status"></a> [consumer\_psc\_connection\_status](#output\_consumer\_psc\_connection\_status) | The PSC connection status of the consumer forwarding rule. |
| <a name="output_psc_forwarding_rule"></a> [psc\_forwarding\_rule](#output\_psc\_forwarding\_rule) | The full forwarding rule resource for consumer PSC. |
| <a name="output_regional_endpoint_id"></a> [regional\_endpoint\_id](#output\_regional\_endpoint\_id) | The ID of the regional endpoint. |
| <a name="output_regional_endpoint_name"></a> [regional\_endpoint\_name](#output\_regional\_endpoint\_name) | The name of the regional endpoint. |
| <a name="output_service_attachment_name"></a> [service\_attachment\_name](#output\_service\_attachment\_name) | The name of the service attachment. |
| <a name="output_service_attachment_self_link"></a> [service\_attachment\_self\_link](#output\_service\_attachment\_self\_link) | The self-link of the service attachment. |
| <a name="output_target_google_api"></a> [target\_google\_api](#output\_target\_google\_api) | The target Google API. |
<!-- END_TF_DOCS -->
