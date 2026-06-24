# GKE Autopilot

This Terraform root module creates a private GKE Autopilot cluster in Google Cloud.

It enables the required Google Cloud APIs and creates one `google_container_cluster` with Autopilot, VPC-native networking, Workload Identity, private nodes, configurable control plane access, logging, monitoring, cost management, security posture, and maintenance settings.

## What It Creates

- Enables these APIs in the target project:
  - `compute.googleapis.com`
  - `iam.googleapis.com`
  - `container.googleapis.com`
  - `run.googleapis.com`
- Creates a GKE Autopilot cluster with:
  - `enable_autopilot = true`
  - `networking_mode = "VPC_NATIVE"`
  - Workload Identity enabled
  - private cluster defaults
  - Dataplane V2 by default
  - L4 ILB subsetting enabled by default
  - external Service IPs disabled by default

The API resources use `disable_on_destroy = false`, so destroying this Terraform stack does not disable the APIs in the project.

## Required Existing Resources

This module does not create the network layer. Before applying it, the following resources must already exist:

- GCP project.
- VPC network.
- Subnet.
- Secondary IP ranges for GKE pods and services, unless CIDR blocks are provided directly.
- Private egress path for workloads, such as Cloud NAT, if workloads need internet access.
- Any required firewall rules, DNS zones, bastion, VPN, or administrative access path.

## Variables To Change

| Variable | Required | What to set |
| --- | --- | --- |
| `project_id` | Yes | Target GCP project ID. |
| `env` | Yes | Environment name, for example `dev`, `stg`, or `prod`. When `env = "prod"`, cluster deletion protection is enabled in `main.tf`. |
| `name` | Yes | GKE cluster name. |
| `location` | Yes | GCP region or zone for the cluster, for example `us-central1` or `southamerica-east1`. |
| `network` | Yes | Existing VPC network name or self link. |
| `subnetwork` | Yes | Existing subnet name or self link. |
| `ip_allocation_policy` | Yes for VPC-native setup | Pod and service secondary range names, or explicit CIDR blocks. |
| `resource_labels` | Recommended | Labels used for ownership, environment, billing, and operations. |
| `description` | Recommended | Short description of the cluster purpose. |
| `control_plane_endpoints_config` | Recommended | DNS and IP endpoint settings for the control plane. The current outputs expect the DNS endpoint block to exist. |
| `private_cluster_config` | Recommended | Private node and private endpoint behavior. Defaults create private nodes. |
| `master_authorized_networks` | Optional | CIDR allowlist for IP-based control plane endpoints. Not required when using DNS-only control plane access. |
| `workload_pool` | Optional | Workload Identity pool. If omitted, it uses `<project_id>.svc.id.goog`. |

Operational defaults can also be adjusted when needed:

| Variable | Default |
| --- | --- |
| `release_channel` | `REGULAR` |
| `logging_config` | `SYSTEM_COMPONENTS`, `WORKLOADS` |
| `monitoring_config` | `SYSTEM_COMPONENTS` |
| `cost_management_config` | enabled |
| `security_posture_config` | `BASIC` and `VULNERABILITY_BASIC` |
| `service_external_ips_config` | disabled |
| `maintenance_policy` | daily window at `05:00` |
| `node_pool_auto_config` | read-only kubelet port disabled and cgroup v2 enabled |
| `timeouts` | `45m` for create, update, and delete |

Note: `deletion_protection` is declared in `variables.tf`, but the current cluster resource uses `env == "prod"` to set deletion protection.

## Example `gkeautopilot.tfvars`

```hcl
project_id = "my-gcp-project"
env        = "dev"
name       = "gke-autopilot-private"
location   = "us-central1"

network    = "my-vpc"
subnetwork = "my-subnet"

resource_labels = {
  environment = "dev"
  managed_by  = "terraform"
  workload    = "gke-autopilot"
}

ip_allocation_policy = {
  cluster_secondary_range_name  = "gke-pods"
  services_secondary_range_name = "gke-services"
}

private_cluster_config = {
  enable_private_nodes    = true
  enable_private_endpoint = true
}

control_plane_endpoints_config = {
  dns_endpoint_config = {
    allow_external_traffic = true
  }

  ip_endpoints_config = {
    enabled = false
  }
}
```

## Usage

Run Terraform from this directory:

```bash
cd modules/gkeautopilot
terraform init
terraform plan
terraform apply
```

## Expected Outputs

| Output | Description |
| --- | --- |
| `cluster_name` | Name of the created GKE cluster. |
| `cluster_id` | Full Terraform/GCP ID of the cluster. |
| `location` | Region or zone where the cluster was created. |
| `endpoint` | Private control plane endpoint. Marked as sensitive. |
| `endpoint_dns` | DNS endpoint for the control plane. |
| `ca_certificate` | Base64-encoded cluster CA certificate. Marked as sensitive. |
| `master_version` | Current GKE control plane version. |
| `node_locations` | Zones used by the Autopilot nodes. |
