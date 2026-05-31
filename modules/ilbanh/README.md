# Internal Load Balancer Active Network Appliance (ILB NVA) Module

This module sets up an Internal Load Balancer (ILB) frontend with backend Virtual Machine instances acting as Network Virtual Appliances (NVAs). It automatically generates internal IP reservations, a regional instance template, instance resources from the template, an unmanaged instance group containing those instances, a regional health check, a backend service, and a regional TCP internal forwarding rule.

## Usage

```hcl
module "ilbanh" {
  source                = "./modules/ilbanh"
  project_id            = "my-project-id"
  name                  = "nva-ilb"
  region                = "us-central1"
  zone                  = "us-central1-a"
  network_id            = "my-vpc-self-link"
  subnetwork_id         = "my-subnet-self-link"
  service_account_email = "my-service-account@my-project-id.iam.gserviceaccount.com"

  vms = {
    "nva01" = {
      address = "10.0.1.10"
    }
    "nva02" = {
      address = "10.0.1.11"
    }
  }
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
| [google_compute_address.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_forwarding_rule.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_instance_from_template.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_from_template) | resource |
| [google_compute_instance_group.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group) | resource |
| [google_compute_region_backend_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |
| [google_compute_region_health_check.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_health_check) | resource |
| [google_compute_region_instance_template.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_can_ip_forward"></a> [can\_ip\_forward](#input\_can\_ip\_forward) | n/a | `bool` | `true` | no |
| <a name="input_desired_status"></a> [desired\_status](#input\_desired\_status) | n/a | `string` | `"RUNNING"` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | n/a | `number` | `10` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | n/a | `string` | `"pd-balanced"` | no |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | n/a | `number` | `80` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | n/a | `string` | `"e2-micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | n/a | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_resource_manager_tags"></a> [resource\_manager\_tags](#input\_resource\_manager\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | n/a | `string` | n/a | yes |
| <a name="input_service_account_scopes"></a> [service\_account\_scopes](#input\_service\_account\_scopes) | n/a | `list(string)` | <pre>[<br/>  "https://www.googleapis.com/auth/devstorage.read_only",<br/>  "https://www.googleapis.com/auth/logging.write",<br/>  "https://www.googleapis.com/auth/monitoring.write",<br/>  "https://www.googleapis.com/auth/service.management.readonly",<br/>  "https://www.googleapis.com/auth/servicecontrol",<br/>  "https://www.googleapis.com/auth/trace.append",<br/>  "https://www.googleapis.com/auth/cloud-platform"<br/>]</pre> | no |
| <a name="input_source_image"></a> [source\_image](#input\_source\_image) | n/a | `string` | `"projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2510-questing-amd64-v20251024"` | no |
| <a name="input_subnetwork_id"></a> [subnetwork\_id](#input\_subnetwork\_id) | n/a | `string` | n/a | yes |
| <a name="input_vm_tags"></a> [vm\_tags](#input\_vm\_tags) | n/a | `list(string)` | <pre>[<br/>  "nva"<br/>]</pre> | no |
| <a name="input_vms"></a> [vms](#input\_vms) | Map of VMs to create in this zone, where the key is the VM suffix (e.g., 'vm01') and value contains the static IP. | <pre>map(object({<br/>    address = string<br/>  }))</pre> | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_forwarding_rule_id"></a> [forwarding\_rule\_id](#output\_forwarding\_rule\_id) | The ID of the internal load balancer forwarding rule. |
| <a name="output_forwarding_rule_ip"></a> [forwarding\_rule\_ip](#output\_forwarding\_rule\_ip) | The IP address of the internal load balancer forwarding rule. |
| <a name="output_instances"></a> [instances](#output\_instances) | The created VM instances for the NVA clusters. |
<!-- END_TF_DOCS -->
