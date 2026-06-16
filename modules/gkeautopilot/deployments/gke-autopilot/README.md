# GKE Autopilot Deployment

This deployment creates a private GKE Autopilot cluster by consuming local Terraform modules:

```hcl
../../modules/services
../../modules/gke-autopilot-cluster
```

It is intended for customers that want a managed Kubernetes platform with lower node operations overhead. Google manages the node layer in Autopilot, while the customer still owns workload design, networking decisions, IAM/RBAC, ingress, observability, and cost governance.



## Module Usage

This directory is the Terraform root module for this deployment. Run Terraform from here, or use `terraform -chdir=deployments/gke-autopilot` from the repository root.

It composes existing modules from this repository:

| Module | Source | Purpose |
|---|---|---|
| `module.services` | `../../modules/services` | Enables the Google Cloud APIs required before creating the cluster. |
| `module.gke_autopilot` | `../../modules/gke-autopilot-cluster` | Creates the GKE Autopilot cluster using the values from this deployment. |

The flow is:

1. `terraform.tfvars` stores the deployment values, such as project, cluster name, region, VPC, subnet, labels, private cluster settings, and release channel.
2. `main.tf` passes those values into `module.gke_autopilot`.
3. `module.gke_autopilot` creates the underlying `google_container_cluster` resource.
4. `module.gke_autopilot` depends on `module.services`, so the required APIs are enabled first.

The dependency is declared explicitly:

```hcl
depends_on = [
  module.services,
]
```

This is needed because the GKE API must be enabled before Terraform can create the cluster.

The cluster name is passed as `name`:

```hcl
name = "gke-autopilot-private"
```

`main.tf` forwards it to the reusable module:

```hcl
name = var.name
```

Inside `../../modules/gke-autopilot-cluster`, that value is used by the actual GKE cluster resource.

## Target Configuration

The current `terraform.tfvars` is prepared for the following known customer configuration:

| Setting | Value |
|---|---|
| Project ID | `your-project-id` |
| Cluster name | `gke-autopilot-private` |
| Region | `us-central1` |
| VPC | `tf-vpc-01` |
| Subnet | `tf-vpc-01-sn01-usc1` |
| Subnet primary range | `192.168.100.0/24` |
| IP allocation policy | `{}` so GKE auto-allocates secondary ranges |
| Cluster mode | GKE Autopilot |
| Cluster endpoint | DNS endpoint enabled; IP-based public/private endpoints disabled |
| Nodes | Private nodes enabled |
| Workload Identity | Enabled through `${project_id}.svc.id.goog` |
| Release channel | `REGULAR` |
| Deletion protection | Enabled only when `env == "prod"` |

## What This Deployment Creates

This deployment creates:

- GKE Autopilot cluster
- required project services through `../../modules/services`

The services module currently enables:

- `compute.googleapis.com`
- `iam.googleapis.com`
- `container.googleapis.com`
- `run.googleapis.com`

It does not create:

- VPC network
- subnet
- secondary IP ranges
- Cloud NAT
- firewall rules
- private DNS zones
- bastion host or VPN access
- Artifact Registry repositories
- application namespaces
- Kubernetes RBAC bindings
- application deployments

Those resources must already exist or be managed by another Terraform layer.

## Why Choose GKE Autopilot Here

Autopilot is the recommended starting point when the customer wants Kubernetes without taking full ownership of node pool operations.

Choose Autopilot when:

- the workloads are general-purpose APIs, services, workers, or internal applications;
- the customer does not need custom node pools or specific machine types;
- the team wants lower operational overhead;
- faster platform rollout is more important than low-level node customization;
- the customer wants to reduce idle node capacity and node sizing work;
- workloads can define realistic CPU and memory requests;
- managed defaults for scaling, security, and node operations are acceptable.

Do not choose Autopilot as the final design if the customer requires:

- custom node pools;
- specific machine families or hardware topology;
- GPUs, local SSDs, sole-tenant nodes, or reservation-based capacity design;
- privileged containers or unsupported low-level node access;
- strict node version control and custom upgrade sequencing;
- Windows nodes or specialized node operating system configuration.

If any of those requirements are confirmed, evaluate GKE Standard instead.

## Required Customer Decisions

Before running `terraform apply`, the customer should confirm the following items.

| Area | Required Decision |
|---|---|
| Environment | Is this cluster for dev, staging, production, or shared demo usage? |
| Region | Confirm that `us-central1` is the correct region for latency, compliance, and existing network design. |
| Control plane access | Confirm which CIDR ranges should be allowed in `master_authorized_networks`. |
| Control plane endpoint | Confirm whether the public control plane endpoint with authorized networks is acceptable for administrator access. |
| NAT and egress | Confirm whether private nodes need outbound internet access through Cloud NAT or another egress design. |
| Ingress model | Decide whether applications will use Gateway API, Ingress, internal load balancers, or external HTTPS load balancers. |
| DNS | Decide whether private DNS or public DNS records are required. |
| IAM/RBAC | Define admin groups, reader groups, and Kubernetes RBAC ownership. |
| Workload Identity | Map Kubernetes service accounts to Google service accounts for each workload. |
| Secrets | Decide whether applications will use Secret Manager, Kubernetes Secrets, or both. |
| Image registry | Confirm Artifact Registry project, repositories, and image promotion flow. |
| Observability | Define required logs, metrics, alerts, dashboards, and audit review process. |
| Backup | Decide whether workloads require GKE Backup or application-level backup. |
| Cost governance | Confirm labels, budget alerts, and cost allocation model. |
| Maintenance | Confirm the maintenance window and release channel policy. |

## Important Defaults

This deployment currently applies these defaults:

| Setting | Default |
|---|---|
| `deletion_protection` | `true` only when `env == "prod"` |
| `private_cluster_config.enable_private_nodes` | `true` |
| `private_cluster_config.enable_private_endpoint` | `false` |
| `ip_allocation_policy` | `{}` |
| `release_channel.channel` | `REGULAR` |
| `vertical_pod_autoscaling.enabled` | `true` |
| `datapath_provider` | `ADVANCED_DATAPATH` |
| `enable_l4_ilb_subsetting` | `true` |
| `service_external_ips_config.enabled` | `false` |
| `cost_management_config.enabled` | `true` |
| `security_posture_config.mode` | `BASIC` |
| `security_posture_config.vulnerability_mode` | `VULNERABILITY_BASIC` |
| `node_pool_auto_config.node_kubelet_config.insecure_kubelet_readonly_port_enabled` | `false` |
| `node_pool_auto_config.linux_node_config.cgroup_mode` | `CGROUP_MODE_V2` |

## Private Cluster Access Note

This cluster is configured with private nodes and the public control plane endpoint enabled:

```hcl
enable_private_nodes    = true
enable_private_endpoint = false
```

That means the cluster nodes do not receive public IP addresses, while administrators can still reach the Kubernetes control plane through the public endpoint when allowed by authorized networks and IAM.

The current configuration intentionally omits explicit pod and service secondary range names:

```hcl
ip_allocation_policy = {}
```

This lets GKE auto-allocate the secondary ranges during cluster creation.

The current authorized network is:

```hcl
master_authorized_networks = [
  {
    display_name = "vpc"
    cidr_block   = "192.168.100.0/24"
  }
]
```

Confirm this CIDR is sufficient for the real administration path. If administrators connect through VPN, bastion, Cloud Workstations, or another subnet, add the correct CIDR before applying.

## How To Use

If the previous cluster was deleted manually in the Google Cloud console, verify whether the local Terraform state still contains it before applying. If state is stale, reconcile state first with the appropriate Terraform state command for your backend and workflow.

From this directory:

```bash
terraform init
terraform validate
terraform plan
```

Apply only after the plan is reviewed:

```bash
terraform apply
```

From the repository root, use:

```bash
terraform -chdir=deployments/gke-autopilot init
terraform -chdir=deployments/gke-autopilot validate
terraform -chdir=deployments/gke-autopilot plan
terraform -chdir=deployments/gke-autopilot apply
```

## Files

| File | Purpose |
|---|---|
| `main.tf` | Calls the local `services` and `gke-autopilot-cluster` modules. |
| `variables.tf` | Defines the deployment input contract. |
| `terraform.tfvars` | Stores the customer-specific values for this deployment. |
| `outputs.tf` | Exposes cluster outputs such as name, location, endpoint, and version. |
| `versions.tf` | Defines Terraform and provider requirements. |

## When To Revisit GKE Standard

Revisit GKE Standard if discovery confirms that the customer needs direct control over:

- node pools;
- machine types;
- GPU or local SSD usage;
- privileged workloads;
- custom kubelet or Linux settings;
- Windows nodes;
- strict upgrade sequencing;
- reservation-based or fixed-capacity cost optimization;
- dedicated workload isolation at the node level.

Until one of those requirements is confirmed, Autopilot remains the simpler and safer default for this deployment.
