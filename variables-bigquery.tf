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

variable "bigquery_datasets" {
  description = "Map of BigQuery dataset configurations. Key is used as the dataset_id. Interface follows terraform-google-modules/bigquery/google (root module)."
  default     = {}
  type = map(object({
    project_id                      = optional(string, null)
    dataset_name                    = optional(string, null)
    description                     = optional(string, null)
    location                        = optional(string, "US")
    delete_contents_on_destroy      = optional(bool, null)
    deletion_protection             = optional(bool, false)
    default_table_expiration_ms     = optional(number, null)
    default_partition_expiration_ms = optional(number, null)
    max_time_travel_hours           = optional(number, null)
    storage_billing_model           = optional(string, null)
    encryption_key                  = optional(string, null)
    dataset_labels                  = optional(map(string), {})
    resource_tags                   = optional(map(string), {})

    access = optional(any, [{
      role          = "roles/bigquery.dataOwner"
      special_group = "projectOwners"
    }])

    tables = optional(list(object({
      table_id                 = string
      description              = optional(string)
      table_name               = optional(string)
      schema                   = string
      clustering               = optional(list(string), [])
      require_partition_filter = optional(bool)
      time_partitioning = optional(object({
        expiration_ms = string
        field         = string
        type          = string
      }), null)
      range_partitioning = optional(object({
        field = string
        range = object({
          start    = string
          end      = string
          interval = string
        })
      }), null)
      expiration_time     = optional(string, null)
      deletion_protection = optional(bool)
      labels              = optional(map(string), {})
    })), [])

    views = optional(list(object({
      view_id        = string
      description    = optional(string)
      query          = string
      use_legacy_sql = bool
      labels         = optional(map(string), {})
    })), [])

    materialized_views = optional(list(object({
      view_id             = string
      description         = optional(string)
      query               = string
      enable_refresh      = bool
      refresh_interval_ms = string
      clustering          = optional(list(string), [])
      time_partitioning = optional(object({
        expiration_ms            = string
        field                    = string
        type                     = string
        require_partition_filter = bool
      }), null)
      range_partitioning = optional(object({
        field = string
        range = object({
          start    = string
          end      = string
          interval = string
        })
      }), null)
      expiration_time = optional(string, null)
      max_staleness   = optional(string)
      labels          = optional(map(string), {})
    })), [])

    external_tables = optional(list(object({
      table_id              = string
      description           = optional(string)
      autodetect            = bool
      compression           = string
      ignore_unknown_values = bool
      max_bad_records       = number
      schema                = string
      source_format         = string
      source_uris           = list(string)
      csv_options = object({
        quote                 = string
        allow_jagged_rows     = bool
        allow_quoted_newlines = bool
        encoding              = string
        field_delimiter       = string
        skip_leading_rows     = number
      })
      google_sheets_options = object({
        range             = string
        skip_leading_rows = number
      })
      hive_partitioning_options = object({
        mode              = string
        source_uri_prefix = string
      })
      expiration_time     = optional(string, null)
      max_staleness       = optional(string)
      deletion_protection = optional(bool)
      labels              = optional(map(string), {})
    })), [])

    routines = optional(list(object({
      routine_id      = string
      routine_type    = string
      language        = string
      definition_body = string
      return_type     = string
      description     = string
      arguments = optional(list(object({
        name          = string
        data_type     = string
        argument_kind = string
        mode          = string
      })), [])
    })), [])
  }))
}
