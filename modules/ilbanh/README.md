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
| project_id | The GCP Project ID where resources will be created | `string` | n/a | yes |
| name | Name prefix for the resources | `string` | n/a | yes |
| region | Region where resources will be deployed | `string` | n/a | yes |
| zone | Zone where the VM instances will be deployed | `string` | n/a | yes |
| network_id | The URL/Self Link of the VPC network | `string` | n/a | yes |
| subnetwork_id | The URL/Self Link of the subnetwork | `string` | n/a | yes |
| vms | Map of VMs to create in this zone, where the key is the VM suffix (e.g., 'vm01') and value contains the static IP. | <pre>map(object({<br>  address = string<br>}))</pre> | n/a | yes |
| machine_type | The machine type for the instances | `string` | `"e2-micro"` | no |
| source_image | The image from which to initialize the boot disk of the instances | `string` | `"projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2510-questing-amd64-v20251024"` | no |
| disk_size_gb | Size of the boot disk in GB | `number` | `10` | no |
| disk_type | The GCE disk type of the boot disk | `string` | `"pd-balanced"` | no |
| vm_tags | List of network tags to apply to the instances | `list(string)` | `["nva"]` | no |
| resource_manager_tags | Resource Manager tag keys and values to attach to the instances | `map(string)` | `{}` | no |
| service_account_email | Email address of the service account to attach to the instances | `string` | n/a | yes |
| service_account_scopes | List of service scopes for the attached service account | `list(string)` | <pre>[<br>  "https://www.googleapis.com/auth/devstorage.read_only",<br>  "https://www.googleapis.com/auth/logging.write",<br>  "https://www.googleapis.com/auth/monitoring.write",<br>  "https://www.googleapis.com/auth/service.management.readonly",<br>  "https://www.googleapis.com/auth/servicecontrol",<br>  "https://www.googleapis.com/auth/trace.append",<br>  "https://www.googleapis.com/auth/cloud-platform"<br>]</pre> | no |
| can_ip_forward | Whether the instances can send and receive packets with non-matching destination or source IPs | `bool` | `true` | no |
| desired_status | The status of the VM instance. Must be either RUNNING or TERMINATED | `string` | `"RUNNING"` | no |
| health_check_port | HTTP health check port to verify backend health | `number` | `80` | no |

## Outputs

This module does not define any outputs.
