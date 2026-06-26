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

variable "name" {
  description = "A user-defined name of the certificate issuance config."
  type        = string
}

variable "description" {
  description = "One or more paragraphs of text description of a certificate issuance config."
  type        = string
  default     = null
}

variable "rotation_window_percentage" {
  description = "It specifies the percentage of lifetime when the certificate trigger rotation. A value between 1 and 99."
  type        = number
  default     = 66
}

variable "key_algorithm" {
  description = "The key algorithm of the certificate. Possible values are: KEY_ALGORITHM_UNSPECIFIED, RSA_2048, ECDSA_P256, ECDSA_P384."
  type        = string
  default     = "RSA_2048"
}

variable "lifetime" {
  description = "Lifetime of the issued certificate. A duration in seconds with up to nine fractional digits, ending with 's'. Example: '1814400s'."
  type        = string
  default     = "2592000s"
}

variable "ca_pool" {
  description = "The CA pool resource ID used to issue certificates."
  type        = string
}

variable "labels" {
  description = "Key-value pair labels associated with the resource."
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "The Certificate Manager location."
  type        = string
  default     = "us-east4"
}

variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
  default     = null
}

variable "members" {
  description = "The members to add to the IAM binding."
  type        = set(string)
  default     = []
}