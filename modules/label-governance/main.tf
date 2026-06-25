/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "terraform_data" "validation" {
  input = var.labels

  lifecycle {
    # Validate Label 1: application_id
    precondition {
      condition     = can(var.labels["application_id"])
      error_message = "Governance Error: The mandatory label 'application_id' is missing."
    }

    # Validate Label 2: environment
    precondition {
      condition     = can(var.labels["environment"])
      error_message = "Governance Error: The mandatory label 'environment' is missing."
    }
    precondition {
      condition     = contains(["dev", "prod"], lookup(var.labels, "environment", ""))
      error_message = "Governance Error: The 'environment' label value must be either 'dev' or 'prod'."
    }

    # Validate Label 3: business_unit
    precondition {
      condition     = can(var.labels["business_unit"])
      error_message = "Governance Error: The mandatory label 'business_unit' is missing."
    }

    # Validate Label 4: data_classification
    precondition {
      condition     = can(var.labels["data_classification"])
      error_message = "Governance Error: The mandatory label 'data_classification' is missing."
    }

    # Validate Label 5: owner_team
    precondition {
      condition     = can(var.labels["owner_team"])
      error_message = "Governance Error: The mandatory label 'owner_team' is missing."
    }
  }
}

# Validate Label 6: managed_by as a Warning
check "managed_by_warning" {
  assert {
    condition     = can(var.labels["managed_by"])
    error_message = "Governance Warning: The 'managed_by' label is recommended but missing."
  }
}

