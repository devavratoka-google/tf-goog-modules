# NCC Hub Module

This module creates a Google Cloud Network Connectivity Center (NCC) Hub and associated groups.

## Usage

```hcl
module "ncc_hub" {
  source      = "./modules/ncc_hub"
  name        = "my-hub"
  description = "My NCC Hub"
  # ... other required variables
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_network_connectivity_group.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_group) | resource |
| [google_network_connectivity_hub.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_hub) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | An optional description of the hub. | `string` | n/a | yes |
| <a name="input_export_psc"></a> [export\_psc](#input\_export\_psc) | Whether Private Service Connect transitivity is enabled for the hub. If true, Private Service Connect endpoints in VPC spokes attached to the hub are made accessible to other VPC spokes attached to the hub. The default value is false. | `bool` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Optional labels in key:value format. | `map(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Immutable. The name of the hub. Hub names must be unique. They use the following form: projects/{project\_number}/locations/global/hubs/{hub\_id} | `string` | n/a | yes |
| <a name="input_ncc_groups"></a> [ncc\_groups](#input\_ncc\_groups) | A map of NCC groups to create. | <pre>map(object({<br/>    description          = string<br/>    auto_accept_projects = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_preset_topology"></a> [preset\_topology](#input\_preset\_topology) | The topology implemented in this hub. Currently, this field is only used when policyMode = PRESET. The available preset topologies are MESH and STAR. If presetTopology is unspecified and policyMode = PRESET, the presetTopology defaults to MESH. When policyMode = CUSTOM, the presetTopology is set to PRESET\_TOPOLOGY\_UNSPECIFIED. Possible values are: MESH, STAR. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ncc_hub_id"></a> [ncc\_hub\_id](#output\_ncc\_hub\_id) | The ID of the NCC Hub. |
| <a name="output_ncc_hub_name"></a> [ncc\_hub\_name](#output\_ncc\_hub\_name) | The name of the NCC Hub. |
| <a name="output_ncc_hub_unique_id"></a> [ncc\_hub\_unique\_id](#output\_ncc\_hub\_unique\_id) | The unique ID of the NCC Hub. |
<!-- END_TF_DOCS -->
