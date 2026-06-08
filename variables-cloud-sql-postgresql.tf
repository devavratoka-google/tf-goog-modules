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

variable "cloud_sql_postgresql" {
  description = "Map of Cloud SQL PostgreSQL instances. Key is used as the instance name. Interface follows terraform-google-modules/sql-db/google//modules/postgresql."
  default     = {}
  type = map(object({
    project_id          = optional(string, null)
    region              = optional(string, "us-central1")
    edition             = optional(string, null)
    database_version    = string
    maintenance_version = optional(string, null)
    availability_type   = optional(string, "ZONAL")

    enable_default_db        = optional(bool, true)
    db_name                  = optional(string, "default")
    enable_default_user      = optional(bool, true)
    user_name                = optional(string, "default")
    user_password            = optional(string, "")
    root_password            = optional(string, null)
    deletion_protection      = optional(bool, true)
    database_deletion_policy = optional(string, null)
    user_deletion_policy     = optional(string, null)
    data_cache_enabled       = optional(bool, false)

    database_flags = optional(list(object({
      name  = string
      value = string
    })), [])

    additional_users = optional(list(object({
      name            = string
      password        = string
      random_password = bool
    })), [])

    additional_databases = optional(list(object({
      name      = string
      charset   = string
      collation = string
    })), [])

    master_instance_name                     = optional(string, null)
    failover_dr_replica_name                 = optional(string, null)
    instance_type                            = optional(string, "CLOUD_SQL_INSTANCE")
    random_instance_name                     = optional(bool, false)
    tier                                     = optional(string, "db-f1-micro")
    zone                                     = optional(string, null)
    secondary_zone                           = optional(string, null)
    follow_gae_application                   = optional(string, null)
    activation_policy                        = optional(string, "ALWAYS")
    deletion_protection_enabled              = optional(bool, false)
    read_replica_deletion_protection_enabled = optional(bool, false)
    disk_autoresize                          = optional(bool, true)
    disk_autoresize_limit                    = optional(number, 0)
    disk_size                                = optional(number, 10)
    disk_type                                = optional(string, "PD_SSD")
    pricing_plan                             = optional(string, "PER_USE")
    maintenance_window_day                   = optional(number, 1)
    maintenance_window_hour                  = optional(number, 23)
    maintenance_window_update_track          = optional(string, "canary")
    user_labels                              = optional(map(string), {})

    deny_maintenance_period = optional(list(object({
      end_date   = string
      start_date = string
      time       = string
    })), [])

    backup_configuration = optional(object({
      enabled                        = optional(bool, false)
      start_time                     = optional(string)
      location                       = optional(string)
      point_in_time_recovery_enabled = optional(bool, false)
      transaction_log_retention_days = optional(string)
      retained_backups               = optional(number)
      retention_unit                 = optional(string)
    }), {})

    final_backup_config = optional(object({
      enabled        = optional(bool, false)
      retention_days = optional(number, 1)
    }), null)

    insights_config = optional(object({
      enhanced_query_insights_enabled = optional(bool, false)
      query_plans_per_minute          = optional(number, 5)
      query_string_length             = optional(number, 1024)
      record_application_tags         = optional(bool, false)
      record_client_address           = optional(bool, false)
    }), null)

    password_validation_policy_config = optional(object({
      min_length                  = optional(number)
      complexity                  = optional(string)
      reuse_interval              = optional(number)
      disallow_username_substring = optional(bool)
      password_change_interval    = optional(string)
    }), null)

    ip_configuration = optional(object({
      authorized_networks                           = optional(list(map(string)), [])
      ipv4_enabled                                  = optional(bool, true)
      private_network                               = optional(string)
      ssl_mode                                      = optional(string)
      allocated_ip_range                            = optional(string)
      enable_private_path_for_google_cloud_services = optional(bool, false)
      psc_enabled                                   = optional(bool, false)
      psc_allowed_consumer_projects                 = optional(list(string), [])
      server_ca_mode                                = optional(string)
      server_ca_pool                                = optional(string)
      custom_subject_alternative_names              = optional(list(string), [])
    }), {})

    read_replicas = optional(list(object({
      name                  = string
      name_override         = optional(string)
      tier                  = optional(string)
      edition               = optional(string)
      availability_type     = optional(string)
      zone                  = optional(string)
      disk_type             = optional(string)
      disk_autoresize       = optional(bool)
      disk_autoresize_limit = optional(number)
      disk_size             = optional(string)
      user_labels           = map(string)
      connection_pool_config = optional(object({
        enabled = optional(bool, false)
        flags = optional(list(object({
          name  = string
          value = string
        })), [])
      }), null)
      database_flags = optional(list(object({
        name  = string
        value = string
      })), [])
      insights_config = optional(object({
        enhanced_query_insights_enabled = optional(bool, false)
        query_plans_per_minute          = optional(number, 5)
        query_string_length             = optional(number, 1024)
        record_application_tags         = optional(bool, false)
        record_client_address           = optional(bool, false)
      }), null)
      final_backup_config = optional(object({
        enabled        = optional(bool, false)
        retention_days = optional(number, 1)
      }), null)
      ip_configuration = object({
        authorized_networks                           = optional(list(map(string)), [])
        ipv4_enabled                                  = optional(bool)
        private_network                               = optional(string)
        ssl_mode                                      = optional(string)
        allocated_ip_range                            = optional(string)
        enable_private_path_for_google_cloud_services = optional(bool, false)
        psc_enabled                                   = optional(bool, false)
        psc_allowed_consumer_projects                 = optional(list(string), [])
      })
      psc_interface_config = optional(object({
        network_attachment_link = string
        consumer_address        = optional(string)
      }), null)
      encryption_key_name = optional(string)
      data_cache_enabled  = optional(bool)
    })), [])

    read_replica_name_suffix = optional(string, "")
    db_charset               = optional(string, "")
    db_collation             = optional(string, "")

    iam_users = optional(list(object({
      id    = string
      email = string
      type  = optional(string)
    })), [])

    create_timeout                   = optional(string, "30m")
    update_timeout                   = optional(string, "30m")
    delete_timeout                   = optional(string, "30m")
    encryption_key_name              = optional(string, null)
    read_replica_deletion_protection = optional(bool, false)
    enable_random_password_special   = optional(bool, false)
    connector_enforcement            = optional(bool, false)
    enable_google_ml_integration     = optional(bool, false)
    enable_dataplex_integration      = optional(bool, false)
    database_integration_roles       = optional(list(string), [])
    use_autokey                      = optional(bool, false)
    create_kms_key_handle            = optional(bool, true)
    kms_key_handle_name              = optional(string, null)
    retain_backups_on_delete         = optional(bool, false)

    connection_pool_config = optional(object({
      enabled = optional(bool, false)
      flags = optional(list(object({
        name  = string
        value = string
      })), [])
    }), null)

    psc_interface_config = optional(object({
      network_attachment_link = string
      consumer_address        = optional(string)
    }), null)
    create_network_attachment                = optional(bool, false)
    network_attachment_name                  = optional(string, null)
    network_attachment_subnetworks           = optional(list(string), [])
    network_attachment_connection_preference = optional(string, "ACCEPT_AUTOMATIC")
    network_attachment_producer_accept_lists = optional(list(string), [])
  }))
}
