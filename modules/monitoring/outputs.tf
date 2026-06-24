output "notification_channel_ids" {
  value = { for k, v in google_monitoring_notification_channel.this : k => v.name }
}
output "alert_policy_names" {
  value = { for k, v in google_monitoring_alert_policy.this : k => v.name }
}
output "uptime_check_ids" {
  value = { for k, v in google_monitoring_uptime_check_config.this : k => v.uptime_check_id }
}
