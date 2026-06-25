# Centralized Label Governance Module

This module implements centralized tag and label validation logic for Google Cloud resources in the enterprise structure.

## Overview
Instead of maintaining duplicate label validation rules inside GKE, Cloud SQL, VM, and other resource modules, those modules call this module to perform validations. If any label requirements fail, Terraform immediately halts execution and prints specific errors.

## Usage

Reference this module inside other resource modules (e.g. `gke`, `cloud-sql`):

```hcl
module "label_validator" {
  source = "../../modules/label-governance"
  labels = var.labels
}

resource "google_sql_database_instance" "instance" {
  name             = "my-db"
  settings {
    user_labels = module.label_validator.validated_labels
  }
}
```

## Mandatory Labels Enforced:
1. `application_id`: Must be provided.
2. `environment`: Must be set to `dev` or `prod`.
3. `business_unit`: Must be provided.
4. `data_classification`: Must be provided.
5. `owner_team`: Must be provided.
6. `managed_by`: Recommended (produces a warning if missing, but does not block).
