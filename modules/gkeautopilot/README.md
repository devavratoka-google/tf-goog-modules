# GKE Autopilot

This directory contains everything needed to deploy a GKE Autopilot cluster using Terraform.

## Directory Structure

```
gkeautopilot/
├── deployments/
│   └── gke-autopilot/      ← use this to create the cluster
├── modules/                ← reusable Terraform modules consumed by the deployment
│   ├── gke-autopilot-cluster/
│   ├── services/
│   └── ...
└── examples/               ← reference examples for study in this stage
```

## How to Use This Module

**The GKE Autopilot cluster must be created from `deployments/gke-autopilot`.**

That folder is the Terraform root module for this deployment. It wires together the reusable modules under `modules/` with the specific configuration values for your cluster.

### Steps

1. Navigate to the deployment folder:

   ```bash
   cd deployments/gke-autopilot
   ```

2. Edit `terraform.tfvars` with your values:

   ```hcl
   project_id = "your-project-id"
   env        = "dev"
   name       = "gke-autopilot-private"
   location   = "us-central1"

   network    = "your-vpc-name"
   subnetwork = "your-subnet-name"

   ip_allocation_policy = {
     cluster_secondary_range_name  = "gke-pods"
     services_secondary_range_name = "gke-services"
   }
   ```

3. Initialize and apply:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## What the Deployment Creates

The deployment in `deployments/gke-autopilot` calls two modules:

| Module | Source | Purpose |
|---|---|---|
| `module.services` | `../../modules/services` | Enables the required Google Cloud APIs (Compute, IAM, Container, Cloud Run). |
| `module.gke_autopilot` | `../../modules/gke-autopilot-cluster` | Creates the GKE Autopilot cluster. |

The `module.gke_autopilot` explicitly depends on `module.services` so that the required APIs are always enabled before the cluster resource is created.

## What the Deployment Does Not Create

The following resources are outside the scope of this deployment and must already exist or be managed by another Terraform layer:

- VPC network and subnet
- Secondary IP ranges for pods and services
- Cloud NAT
- Firewall rules
- Private DNS zones
- Bastion host or VPN access
- Artifact Registry repositories
- Application namespaces and Kubernetes RBAC bindings

## About the `modules/` Folder

The `modules/` folder contains the reusable low-level Terraform modules. You do not run Terraform directly from these folders. They are consumed by the deployment in `deployments/gke-autopilot`.

## About the `examples/` Folder

The `examples/` folder contains a large collection of reference examples covering many GKE configurations (private clusters, autopilot, standard, workload identity, safer cluster, and others). These examples are **for study and reference only** in this stage. 
