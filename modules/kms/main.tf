/**
 * Copyright 2018 Google LLC
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
# TODO: Update the source path below to the remote repository URL if hosting in a separate harness repository.
module "label_governance" {
  source = "../label-governance"
  labels = coalesce(var.labels, {})
}

locals {
  keys_by_name = zipmap(var.keys, var.prevent_destroy ? slice(google_kms_crypto_key.key[*].id, 0, length(var.keys)) : slice(google_kms_crypto_key.key_ephemeral[*].id, 0, length(var.keys)))

  _iam_additive_flat = flatten([
    for key_name, roles in var.iam_additive : [
      for role, members in roles : [
        for member in members : {
          key_name = key_name
          role     = role
          member   = member
        }
      ]
    ]
  ])
}

resource "google_kms_key_ring" "key_ring" {
  name     = var.keyring
  project  = var.project_id
  location = var.location
}

resource "google_kms_crypto_key" "key" {
  count                         = var.prevent_destroy ? length(var.keys) : 0
  name                          = var.keys[count.index]
  key_ring                      = google_kms_key_ring.key_ring.id
  rotation_period               = var.key_rotation_period
  purpose                       = var.purpose
  import_only                   = var.import_only
  skip_initial_version_creation = var.skip_initial_version_creation
  crypto_key_backend            = var.crypto_key_backend

  lifecycle {
    prevent_destroy = true
  }

  destroy_scheduled_duration = var.key_destroy_scheduled_duration

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = module.label_governance.validated_labels
}

resource "google_kms_crypto_key" "key_ephemeral" {
  count                         = var.prevent_destroy ? 0 : length(var.keys)
  name                          = var.keys[count.index]
  key_ring                      = google_kms_key_ring.key_ring.id
  rotation_period               = var.key_rotation_period
  purpose                       = var.purpose
  import_only                   = var.import_only
  skip_initial_version_creation = var.skip_initial_version_creation
  crypto_key_backend            = var.crypto_key_backend

  lifecycle {
    prevent_destroy = false
  }

  destroy_scheduled_duration = var.key_destroy_scheduled_duration

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = module.label_governance.validated_labels
}

resource "google_kms_crypto_key_iam_binding" "owners" {
  count         = length(var.set_owners_for)
  role          = "roles/owner"
  crypto_key_id = local.keys_by_name[var.set_owners_for[count.index]]
  members       = compact(split(",", var.owners[count.index]))
}

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  count         = length(var.set_decrypters_for)
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  crypto_key_id = local.keys_by_name[var.set_decrypters_for[count.index]]
  members       = compact(split(",", var.decrypters[count.index]))
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  count         = length(var.set_encrypters_for)
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  crypto_key_id = local.keys_by_name[element(var.set_encrypters_for, count.index)]
  members       = compact(split(",", var.encrypters[count.index]))
}

resource "google_kms_crypto_key_iam_member" "additive" {
  for_each = {
    for e in local._iam_additive_flat : "${e.key_name}/${e.role}/${e.member}" => e
  }

  crypto_key_id = local.keys_by_name[each.value.key_name]
  role          = each.value.role
  member        = each.value.member
}

resource "google_tags_location_tag_binding" "binding" {
  for_each  = var.tag_bindings
  parent    = "//cloudkms.googleapis.com/${google_kms_key_ring.key_ring.id}"
  tag_value = each.value
  location  = var.location
}

