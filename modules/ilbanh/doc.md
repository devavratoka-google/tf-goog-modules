---

## Executive Readout: GCP Infrastructure Deployment for Obin Agents

**Overview**
A foundational Google Cloud Platform (GCP) environment has been provisioned to host Obin agent workloads. The architecture utilizes a centralized Shared VPC model to enforce strict security and network governance, while attaching dedicated service projects to empower individual engineering teams. This setup prioritizes high availability, tight compliance, and logical segmentation for current and future production requirements.

### 1. VPC & Project Architecture

To balance central governance with decentralized deployment, the environment uses a host-and-service project topology.

* **Dedicated Shared VPC (Host):** `vpc-g-obininfra-dev`
* **Attached Obin Service Projects:**
* `nyl-pr-nyl360-portal-dev-01`
* `nyl-pr-nyl360-robin-dev-01`
* `nyl-pr-nyl360-solution-dev-01`
* `nyl-pr-nyl360-data-dev-01`



### 2. Regions & High Availability

For enterprise resiliency and failover readiness, the deployment spans two regions:

* **Primary:** `us-east4`
* **Secondary:** `us-west1`

### 3. Network Segmentation & IP Addressing

Traffic is logically isolated via dedicated subnets mapped to specific teams and compute types. Private Google Access is enabled on all workload subnets.

**US-East4 (Primary) Subnet Allocations:**

| Subnet Name | CIDR / Range | Purpose |
| --- | --- | --- |
| `vpc-g-obininfra-dev-sn01-use4` | 10.107.3.0/26 | Portal team - DVE |
| `vpc-g-obininfra-dev-sn02-use4` | 10.107.3.64/26 | Robin team - DVE |
| `vpc-g-obininfra-dev-sn03-use4` | 10.107.3.128/26 | Solution team - DVE |
| `vpc-g-obininfra-dev-sn04-use4` | 10.107.3.192/26 | DVE - reserved |
| `vpc-g-obininfra-dev-gke01-use4` | 10.107.5.0/24 | GKE - Robin |
| *↳ Pods secondary range* | *100.72.0.0/23* | *GKE Pods* |
| *↳ Services secondary range* | *100.72.2.0/23* | *GKE Services* |
| `vpc-g-obininfra-dev-rmproxy-use4` | 10.107.4.0/26 | Regional Managed Proxy for L7 ILB |
| `vpc-g-obininfra-dev-pscc-use4` | 10.107.4.128/26 | Private Service Connect |

**US-West1 (Secondary) Subnet Allocations:**

| Subnet Name | CIDR / Range | Purpose |
| --- | --- | --- |
| `vpc-g-obininfra-dev-sn01-usw1` | 10.117.3.0/26 | Portal team - DVE |
| `vpc-g-obininfra-dev-sn02-usw1` | 10.117.3.64/26 | Robin team - DVE |
| `vpc-g-obininfra-dev-sn03-usw1` | 10.117.3.128/26 | Solution team - DVE |
| `vpc-g-obininfra-dev-sn04-usw1` | 10.117.3.192/26 | DVE - reserved |
| `vpc-g-obininfra-dev-gke01-usw1` | 10.117.5.0/24 | GKE - Robin |
| *↳ Pods secondary range* | *100.73.0.0/23* | *GKE Pods* |
| *↳ Services secondary range* | *100.73.2.0/23* | *GKE Services* |
| `vpc-g-obininfra-dev-rmproxy-usw1` | 10.117.4.0/26 | Regional Managed Proxy for L7 ILB |
| `vpc-g-obininfra-dev-pscc-usw1` | 10.117.4.128/26 | Private Service Connect |

### 4. IAM & Subnet-Level Permissions

To enforce least-privilege access, the Harness IACM deploy service accounts (SAs) for each Obin service project have been granted the `roles/compute.networkUser` role exclusively on the subnets necessary for their pipelines:

* **Portal SA:** Assigned to `sn01` (DVE), `rmproxy`, and `pscc` subnets in both regions.
* **Robin SA:** Assigned to `sn02` (DVE), `gke01`, and `pscc` subnets in both regions.
* **Solution SA:** Assigned to `sn03` (DVE) and `pscc` subnets in both regions.
* **Data SA:** Assigned to `pscc` subnets in both regions.

### 5. Routing, Connectivity, & Egress

All egress and internal routing adhere to strict organizational compliance mandates:

* **Hub & Spoke Integration:** An NCC spoke (`spk-vpc-g-obininfra-dev`) is attached to the central hub (`nyl-ncc-hub01`) within `nyl-pr-ssvcs-transit-nw-01`. This enables secure connectivity to other internal spokes and on-premises infrastructure.
* **Zero Public Egress:** There is no direct internet egress from the Obin subnets. All outbound internet traffic routes through the centralized FlexGW VPC for Cloud NAT and security inspection.
* **Default Route:** `0.0.0.0/0` directs to the next hop ILB `10.151.1.2` (egress via FlexGW for inspection).
* **Private Google Access Route:** `199.36.153.8/30` directs to the default internet gateway for secure internal GCP API access.
* **Architecture Reference:** For a visual map of how external traffic enters, how cross-project components interact via Shared VPC, and how data safely replicates to Cloud SQL, please refer to the attached architecture diagram: `123.png`.

### 6. Notes & Next Steps for Engineering

The infrastructure is fully operational. Development teams should note the following when deploying resources:

* **Team Targeting:** Please use the appropriate subnet for your specific team based on the IP allocation mapping above.
* **GKE Deployments:** GKE clusters must target the `gke01` subnets to utilize the pre-allocated pods and services secondary ranges.
* **Load Balancing:** The `rmproxy` subnets are fully established for L7 internal load balancers. No additional network action is required to utilize them.
* **Ongoing Support:** Reach out to the infrastructure team if additional subnet bindings, new firewall rules, or DNS zones need to be added to the environment.