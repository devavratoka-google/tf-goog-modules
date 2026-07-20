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

variable "cloud_sql_mssql" {
  description = "Map of Cloud SQL MSSQL (SQL Server) instances. Key is used as the instance name. Interface follows terraform-google-modules/sql-db/google//modules/mssql."
  default     = {}
  type = map(object({
    project_id                      = optional(string, null)
    master_instance_name            = optional(string, null)
    instance_type                   = optional(string, "CLOUD_SQL_INSTANCE")
    random_instance_name            = optional(bool, false)
    maintenance_version             = optional(string, null)
    database_version                = optional(string, "SQLSERVER_2017_STANDARD")
    region                          = optional(string, "us-central1")
    tier                            = optional(string, "db-custom-2-3840")
    edition                         = optional(string, null)
    zone                            = optional(string, null)
    secondary_zone                  = optional(string, null)
    follow_gae_application          = optional(string, null)
    activation_policy               = optional(string, "ALWAYS")
    availability_type               = optional(string, "ZONAL")
    deletion_protection_enabled     = optional(bool, false)
    disk_autoresize                 = optional(bool, true)
    disk_autoresize_limit           = optional(number, 0)
    disk_size                       = optional(number, 10)
    disk_type                       = optional(string, "PD_SSD")
    pricing_plan                    = optional(string, "PER_USE")
    maintenance_window_day          = optional(number, 1)
    maintenance_window_hour         = optional(number, 23)
    maintenance_window_update_track = optional(string, "canary")

    deny_maintenance_period = optional(list(object({
      end_date   = string
      start_date = string
      time       = string
    })), [])

    database_flags = optional(list(object({
      name  = string
      value = string
    })), [])

    data_cache_enabled      = optional(bool, false)
    active_directory_config = optional(map(string), {})
    sql_server_audit_config = optional(map(string), {})
    user_labels             = optional(map(string), {})

    ip_configuration = optional(object({
      authorized_networks = optional(list(map(string)), [])
      ipv4_enabled        = optional(bool)
      private_network     = optional(string)
      allocated_ip_range  = optional(string)
      ssl_mode            = optional(string)
      }), {
      authorized_networks = []
      ipv4_enabled        = true
      private_network     = null
      allocated_ip_range  = null
      ssl_mode            = null
    })

    backup_configuration = optional(object({
      binary_log_enabled             = bool
      enabled                        = bool
      point_in_time_recovery_enabled = bool
      start_time                     = string
      transaction_log_retention_days = string
      retained_backups               = number
      retention_unit                 = string
      location                       = string
      }), {
      binary_log_enabled             = null
      enabled                        = false
      point_in_time_recovery_enabled = null
      start_time                     = null
      transaction_log_retention_days = null
      retained_backups               = null
      retention_unit                 = null
      location                       = null
    })

    retain_backups_on_delete = optional(bool, false)
    db_name                  = optional(string, "default")
    db_charset               = optional(string, "")
    db_collation             = optional(string, "")

    additional_databases = optional(list(object({
      name      = string
      charset   = string
      collation = string
    })), [])

    user_name     = optional(string, "default")
    user_password = optional(string, "")

    additional_users = optional(list(object({
      name            = string
      password        = string
      random_password = bool
    })), [])

    root_password               = optional(string, "")
    create_timeout              = optional(string, "30m")
    update_timeout              = optional(string, "30m")
    delete_timeout              = optional(string, "30m")
    encryption_key_name         = optional(string, null)
    deletion_protection         = optional(bool, true)
    connector_enforcement       = optional(bool, false)
    time_zone                   = optional(string, null)
    enable_default_db           = optional(bool, true)
    enable_default_user         = optional(bool, true)
    enable_dataplex_integration = optional(bool, false)

    insights_config = optional(object({
      enhanced_query_insights_enabled = optional(bool, false)
      query_plans_per_minute          = optional(number, 5)
      query_string_length             = optional(number, 1024)
      record_application_tags         = optional(bool, false)
      record_client_address           = optional(bool, false)
    }), null)

    final_backup_config = optional(object({
      enabled        = optional(bool, false)
      retention_days = optional(number, 0)
    }), null)

    tag_bindings = optional(map(string), {})
  }))
}

