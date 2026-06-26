# Label Governance and Validation Guide

This guide documents the implementation of the centralized **Label Governance** validation system across the Google Cloud Platform (GCP) IaC Terraform modules in this repository.

## Overview
To enforce organizational standards and metadata compliance, a centralized validator module (`label-governance`) validates resource labels before deployment. If mandatory labels are missing, the Terraform execution will fail during the plan phase, halting deployment.

### Mandatory Governance Labels
* `application_id`
* `environment` (e.g. `dev`, `prod`)
* `business_unit`
* `data_classification`
* `owner_team`
* `managed_by` (optional/recommended warning)

---

## 1. Supported Modules (Label Validation Enabled)
The following modules accept `labels` (or custom parameters like `user_labels`), call the centralized validator, and enforce label governance:

| Module Folder / Path | Variable Used | Resources Validated |
|---|---|---|
| `modules/addresses` | `labels` | `google_compute_address` |
| `modules/bigquery` | `labels` | `google_bigquery_dataset` |
| `modules/certmgr_issuance_config` | `labels` | `google_certificate_manager_certificate_issuance_config` |
| `modules/cloud-run-v2` | `labels` | `google_cloud_run_v2_service`, `google_cloud_run_v2_job`, `google_cloud_run_v2_worker_pool` |
| `modules/cloud-sql-mssql` | `user_labels` | `google_sql_database_instance` |
| `modules/cloud-sql-mysql` | `user_labels` | `google_sql_database_instance` |
| `modules/cloud-sql-postgresql` | `user_labels` | `google_sql_database_instance`, `google_compute_address`, `google_compute_forwarding_rule` |
| `modules/dns` | `labels` | `google_dns_managed_zone` |
| `modules/gar` | `labels` | `google_artifact_registry_repository` |
| `modules/gcs` | `labels` | `google_storage_bucket` |
| `modules/gkeautopilot` | `labels` & `resource_labels` | `google_container_cluster` |
| `modules/global_addresses` | `labels` | `google_compute_global_address` |
| `modules/ilbanh` | `labels` | `google_compute_address`, `google_compute_region_instance_template`, `google_compute_instance_from_template`, `google_compute_forwarding_rule` |
| `modules/kms` | `labels` | `google_kms_crypto_key` |
| `modules/lb/forwarding_rule` | `labels` | `google_compute_forwarding_rule` |
| `modules/lb/lb_traffic_extension` | `labels` | `google_network_services_lb_traffic_extension` |
| `modules/ncc_hub` | `labels` | `google_network_connectivity_hub`, `google_network_connectivity_group` |
| `modules/ncc_spoke` | `labels` | `google_network_connectivity_spoke` |
| `modules/ngfw_endpoint` | `labels` | `google_network_security_firewall_endpoint`, `google_network_security_firewall_endpoint_association` |
| `modules/policy_based_routes` | `labels` | `google_network_connectivity_policy_based_route` |
| `modules/pscendpoints` | `labels` | `google_compute_global_address`, `google_network_connectivity_regional_endpoint`, `google_compute_global_forwarding_rule`, `google_compute_forwarding_rule` |
| `modules/pubsub` | `labels` | `google_pubsub_topic`, `google_pubsub_subscription` |
| `modules/secret-manager` | `labels` | `google_secret_manager_secret` |
| `modules/vertex_ai/model_garden` | `labels` | `google_vertex_ai_endpoint` |
| `modules/vlan-attachments` | `labels` | `google_compute_interconnect_attachment`, `google_network_management_vpc_flow_logs_config` |

---

## 2. Special / Validator Modules
* **`modules/label-governance`**: This is the centralized policy validation engine containing all structural checks and organization requirements. It is imported by the supported modules above, rather than deploying resources directly.

---

## 3. Unsupported Modules (No GCP Label Support)
The following modules do not support label governance because the underlying GCP resource type does not support labels at the GCP API level:

| Module Folder | GCP API / Terraform Resources | Reason / Explanation |
|---|---|---|
| `modules/cloud-scheduler` | `google_cloud_scheduler_job` | Cloud Scheduler jobs do not support labels in the Terraform Google provider. |
| `modules/cloud_nat` | `google_compute_router_nat` | Cloud NAT Gateways do not support labels. |
| `modules/cloud_router` | `google_compute_router` | Cloud Routers do not support labels. |
| `modules/dns_policy` | `google_dns_policy` | DNS Policy resources do not support labels. |
| `modules/dns_record_set` | `google_dns_record_set` | DNS Record Sets do not support labels. |
| `modules/firestore` | `google_firestore_database` | Firestore database instances do not support labels. |
| `modules/iam-custom-role` | `google_project_iam_custom_role` | Custom IAM Roles do not support labels. |
| `modules/iam-service-account` | `google_service_account` | IAM Service Accounts do not support labels. |
| `modules/logging-sink` | `google_logging_project_sink` | Stackdriver Logging Sinks do not support labels. |
| `modules/monitoring` | `google_monitoring_alert_policy` | Dashboards, Alert Notification Channels, and standard monitoring alert policies do not support labels in the module context. |
| `modules/network_attachments` | `google_compute_network_attachment` | Network Attachments do not support labels. |
| `modules/ngfw_hfw` | `google_compute_firewall_policy` | Next Generation Hierarchical Firewall Policies do not support labels. |
| `modules/ngfw_nwfw` | `google_compute_firewall_policy` | Next Generation Network Firewall Policies do not support labels. |
| `modules/project-iam` | `google_project_iam_member` | Project IAM policies and Member bindings do not support labels. |
| `modules/project-services` | `google_project_service` | Activating GCP services does not support labels. |
| `modules/psa` | `google_service_networking_connection` | Service Networking Peering connections do not support labels. |
| `modules/secret-manager-iam` | `google_secret_manager_secret_iam_member` | IAM Member bindings do not support labels (only the parent Secret resource does). |
| `modules/secure_tags` | `google_tags_tag_key`, `google_tags_tag_value` | Secure Tags are a separate GCP metadata namespace and do not accept labels. |
| `modules/shared_vpc` | `google_compute_shared_vpc_service_project` | Shared VPC project links do not support labels. |
| `modules/static_routes` | `google_compute_route` | Compute Routes do not support labels. |
| `modules/subnet_iam_binding` | `google_compute_subnetwork_iam_binding` | Subnet IAM bindings do not support labels. |
| `modules/subnetworks` | `google_compute_subnetwork` | Subnetworks do not support labels. |
| `modules/vertex-ai-reasoning-engine` | `google_vertex_ai_reasoning_engine` | Reasoning Engines do not support labels. |
| `modules/vpc` | `google_compute_network` | GCP VPC Network API does not support labels. |
| `modules/vpc_firewall` | `google_compute_firewall` | Legacy VPC Firewall Rules do not support labels. |
| `modules/vpc_peering` | `google_compute_network_peering` | VPC Network Peering configurations do not support labels. |
