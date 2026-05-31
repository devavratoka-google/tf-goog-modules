# terraform-google-sql for MSSQL Server

> **Upstream source:** This module is a **verbatim copy** of
> [`terraform-google-modules/terraform-google-sql-db` → `modules/mssql`](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/mssql)
> (published on the Terraform Registry as `terraform-google-modules/sql-db/google//modules/mssql`).
> Do **not** modify the `.tf` files locally; sync from upstream instead:
>
> ```bash
> cp /path/to/terraform-google-sql-db/modules/mssql/*.tf \
>    ./modules/cloud-sql-mssql/
> ```
>
> No local divergences (only `hashicorp/google`, `hashicorp/google-beta`, `hashicorp/random`, `hashicorp/null` providers are used).

The following dependency must be available for SQL Server module:

## Usage
Functional examples are included in the [examples](../../examples/) directory. If you want to create an instance with failover replica and manage lifecycle of primary and secondary instance lifecycle using this module follow example in [mssql-failover-replica](../../examples/mssql-failover-replica/)

Basic usage of this module is as follows:

- Create simple Postgresql instance with read replica

```hcl
module "mssql" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 28.1"

  name                 = var.name
  random_instance_name = true
  project_id           = var.project_id
  user_name            = "simpleuser"
  user_password        = "foobar"

  deletion_protection = false

  sql_server_audit_config = var.sql_server_audit_config
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
Copyright 2024 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_sql_database_instance.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_sql_database_instance) | resource |
| [google_sql_database.additional_databases](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_user.additional_users](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [google_sql_user.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [null_resource.module_depends_on](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.additional_passwords](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.root-password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.user-password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activation_policy"></a> [activation\_policy](#input\_activation\_policy) | The activation policy for the Cloud SQL instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | `string` | `"ALWAYS"` | no |
| <a name="input_active_directory_config"></a> [active\_directory\_config](#input\_active\_directory\_config) | Active domain that the SQL instance will join. | `map(string)` | `{}` | no |
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | A list of databases to be created in your cluster | <pre>list(object({<br/>    name      = string<br/>    charset   = string<br/>    collation = string<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set. | <pre>list(object({<br/>    name            = string<br/>    password        = string<br/>    random_password = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type for the Cloud SQL instance.This is only used to set up high availability for the MSSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | The database backup configuration. | <pre>object({<br/>    binary_log_enabled             = bool<br/>    enabled                        = bool<br/>    point_in_time_recovery_enabled = bool<br/>    start_time                     = string<br/>    transaction_log_retention_days = string<br/>    retained_backups               = number<br/>    retention_unit                 = string<br/>    location                       = string<br/>  })</pre> | <pre>{<br/>  "binary_log_enabled": null,<br/>  "enabled": false,<br/>  "location": null,<br/>  "point_in_time_recovery_enabled": null,<br/>  "retained_backups": null,<br/>  "retention_unit": null,<br/>  "start_time": null,<br/>  "transaction_log_retention_days": null<br/>}</pre> | no |
| <a name="input_connector_enforcement"></a> [connector\_enforcement](#input\_connector\_enforcement) | Enforce that clients use the connector library | `bool` | `false` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | The optional timeout that is applied to limit long database creates. | `string` | `"30m"` | no |
| <a name="input_data_cache_enabled"></a> [data\_cache\_enabled](#input\_data\_cache\_enabled) | Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE\_PLUS tier and supported database\_versions | `bool` | `false` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The database flags for the Cloud SQL. See [more details](https://cloud.google.com/sql/docs/sqlserver/flags) | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | The database version to use: SQLSERVER\_2017\_STANDARD, SQLSERVER\_2017\_ENTERPRISE, SQLSERVER\_2017\_EXPRESS, or SQLSERVER\_2017\_WEB | `string` | `"SQLSERVER_2017_STANDARD"` | no |
| <a name="input_db_charset"></a> [db\_charset](#input\_db\_charset) | The charset for the default database | `string` | `""` | no |
| <a name="input_db_collation"></a> [db\_collation](#input\_db\_collation) | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the default database to create | `string` | `"default"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | The optional timeout that is applied to limit long database deletes. | `string` | `"30m"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enables protection of an instance from accidental deletion protection across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| <a name="input_deny_maintenance_period"></a> [deny\_maintenance\_period](#input\_deny\_maintenance\_period) | The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. List accepts only one value. See [more details](https://cloud.google.com/sql/docs/sqlserver/maintenance) | <pre>list(object({<br/>    end_date   = string<br/>    start_date = string<br/>    time       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_disk_autoresize"></a> [disk\_autoresize](#input\_disk\_autoresize) | Configuration to increase storage size. | `bool` | `true` | no |
| <a name="input_disk_autoresize_limit"></a> [disk\_autoresize\_limit](#input\_disk\_autoresize\_limit) | The maximum size to which storage can be auto increased. | `number` | `0` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The disk size for the Cloud SQL instance. | `number` | `10` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The disk type for the Cloud SQL instance. | `string` | `"PD_SSD"` | no |
| <a name="input_edition"></a> [edition](#input\_edition) | The edition of the instance, can be ENTERPRISE or ENTERPRISE\_PLUS. | `string` | `null` | no |
| <a name="input_enable_dataplex_integration"></a> [enable\_dataplex\_integration](#input\_enable\_dataplex\_integration) | Enable database Dataplex integration | `bool` | `false` | no |
| <a name="input_enable_default_db"></a> [enable\_default\_db](#input\_enable\_default\_db) | Enable or disable the creation of the default database | `bool` | `true` | no |
| <a name="input_enable_default_user"></a> [enable\_default\_user](#input\_enable\_default\_user) | Enable or disable the creation of the default user | `bool` | `true` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| <a name="input_final_backup_config"></a> [final\_backup\_config](#input\_final\_backup\_config) | The final\_backup\_config settings for the database. | <pre>object({<br/>    enabled        = optional(bool, false)<br/>    retention_days = optional(number, 0)<br/>  })</pre> | `null` | no |
| <a name="input_follow_gae_application"></a> [follow\_gae\_application](#input\_follow\_gae\_application) | A Google App Engine application whose zone to remain in. Must be in the same region as this instance. | `string` | `null` | no |
| <a name="input_insights_config"></a> [insights\_config](#input\_insights\_config) | The insights\_config settings for the database. | <pre>object({<br/>    enhanced_query_insights_enabled = optional(bool, false)<br/>    query_plans_per_minute          = optional(number, 5)<br/>    query_string_length             = optional(number, 1024)<br/>    record_application_tags         = optional(bool, false)<br/>    record_client_address           = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of the instance. The supported values are SQL\_INSTANCE\_TYPE\_UNSPECIFIED, CLOUD\_SQL\_INSTANCE, ON\_PREMISES\_INSTANCE and READ\_REPLICA\_INSTANCE. Set to READ\_REPLICA\_INSTANCE when primary\_instance\_name is provided | `string` | `"CLOUD_SQL_INSTANCE"` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | The ip configuration for the Cloud SQL instances. | <pre>object({<br/>    authorized_networks = optional(list(map(string)), [])<br/>    ipv4_enabled        = optional(bool)<br/>    private_network     = optional(string)<br/>    allocated_ip_range  = optional(string)<br/>    ssl_mode            = optional(string)<br/>  })</pre> | <pre>{<br/>  "allocated_ip_range": null,<br/>  "authorized_networks": [],<br/>  "ipv4_enabled": true,<br/>  "private_network": null,<br/>  "ssl_mode": null<br/>}</pre> | no |
| <a name="input_maintenance_version"></a> [maintenance\_version](#input\_maintenance\_version) | The current software version on the instance. This attribute can not be set during creation. Refer to available\_maintenance\_versions attribute to see what maintenance\_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance\_version value that is older than the current one on the instance will be ignored | `string` | `null` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | The day of week (1-7) for the Cloud SQL maintenance. | `number` | `1` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | The hour of day (0-23) maintenance window for the Cloud SQL maintenance. | `number` | `23` | no |
| <a name="input_maintenance_window_update_track"></a> [maintenance\_window\_update\_track](#input\_maintenance\_window\_update\_track) | The update track of maintenance window for the Cloud SQL maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| <a name="input_master_instance_name"></a> [master\_instance\_name](#input\_master\_instance\_name) | Name of the master instance if this is a failover replica. Required for creating failover replica instance. Not needed for master instance. When removed, next terraform apply will promote this failover failover replica instance as master instance | `string` | `null` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Cloud SQL instance | `string` | n/a | yes |
| <a name="input_pricing_plan"></a> [pricing\_plan](#input\_pricing\_plan) | The pricing plan for the Cloud SQL instance. | `string` | `"PER_USE"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| <a name="input_random_instance_name"></a> [random\_instance\_name](#input\_random\_instance\_name) | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| <a name="input_retain_backups_on_delete"></a> [retain\_backups\_on\_delete](#input\_retain\_backups\_on\_delete) | When this parameter is set to true, Cloud SQL retains backups of the instance even after the instance is deleted. The ON\_DEMAND backup will be retained until customer deletes the backup or the project. The AUTOMATED backup will be retained based on the backups retention setting. | `bool` | `false` | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | MSSERVER password for the root user. If not set, a random one will be generated and available in the root\_password output variable. | `string` | `""` | no |
| <a name="input_secondary_zone"></a> [secondary\_zone](#input\_secondary\_zone) | The preferred zone for the read replica instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |
| <a name="input_sql_server_audit_config"></a> [sql\_server\_audit\_config](#input\_sql\_server\_audit\_config) | SQL server audit config settings. | `map(string)` | `{}` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | The tier for the Cloud SQL instance. | `string` | `"db-custom-2-3840"` | no |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | The time zone for Cloud SQL instance. | `string` | `null` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | The optional timeout that is applied to limit long database updates. | `string` | `"30m"` | no |
| <a name="input_user_labels"></a> [user\_labels](#input\_user\_labels) | The key/value labels for the Cloud SQL instances. | `map(string)` | `{}` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | The name of the default user | `string` | `"default"` | no |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone for the Cloud SQL instance. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_users"></a> [additional\_users](#output\_additional\_users) | List of maps of additional users and passwords |
| <a name="output_apphub_service_uri"></a> [apphub\_service\_uri](#output\_apphub\_service\_uri) | Service URI in CAIS style to be used by Apphub. |
| <a name="output_generated_user_password"></a> [generated\_user\_password](#output\_generated\_user\_password) | The auto generated default user password if not input password was provided |
| <a name="output_instance_address"></a> [instance\_address](#output\_instance\_address) | The IPv4 addesses assigned for the master instance |
| <a name="output_instance_connection_name"></a> [instance\_connection\_name](#output\_instance\_connection\_name) | The connection name of the master instance to be used in connection strings |
| <a name="output_instance_first_ip_address"></a> [instance\_first\_ip\_address](#output\_instance\_first\_ip\_address) | The first IPv4 address of the addresses assigned. |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | The instance name for the master instance |
| <a name="output_instance_self_link"></a> [instance\_self\_link](#output\_instance\_self\_link) | The URI of the master instance |
| <a name="output_instance_server_ca_cert"></a> [instance\_server\_ca\_cert](#output\_instance\_server\_ca\_cert) | The CA certificate information used to connect to the SQL instance via SSL |
| <a name="output_instance_service_account_email_address"></a> [instance\_service\_account\_email\_address](#output\_instance\_service\_account\_email\_address) | The service account email address assigned to the master instance |
| <a name="output_primary"></a> [primary](#output\_primary) | The `google_sql_database_instance` resource representing the primary instance |
| <a name="output_private_address"></a> [private\_address](#output\_private\_address) | The private IP address assigned for the master instance |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | MSSERVER password for the root user. If not set, a random one will be generated and available in the root\_password output variable. |
<!-- END_TF_DOCS -->
