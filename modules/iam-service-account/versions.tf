# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Fabric release: v55.1.0

terraform {
  required_version = ">= 1.12.2"

  # Local-only divergence from upstream: required_providers removed so providers
  # are inherited from the root module. The root providers.tf is the single
  # source of truth for provider versions.

  provider_meta "google" {
    module_name = "google-pso-tool/cloud-foundation-fabric/modules/iam-service-account:v55.1.0-tf"
  }
  provider_meta "google-beta" {
    module_name = "google-pso-tool/cloud-foundation-fabric/modules/iam-service-account:v55.1.0-tf"
  }
}
