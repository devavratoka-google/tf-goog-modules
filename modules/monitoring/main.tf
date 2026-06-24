resource "google_monitoring_notification_channel" "this" {
  for_each = var.notification_channels

  project      = var.project_id
  display_name = each.key
  type         = each.value.type
  labels       = each.value.labels
}

resource "google_monitoring_uptime_check_config" "this" {
  for_each = var.uptime_checks

  project      = var.project_id
  display_name = each.value.display_name
  timeout      = each.value.timeout
  period       = each.value.period

  dynamic "http_check" {
    for_each = each.value.http_check != null ? [each.value.http_check] : []
    content {
      path         = http_check.value.path
      port         = http_check.value.port
      use_ssl      = http_check.value.use_ssl
      validate_ssl = http_check.value.validate_ssl
    }
  }

  monitored_resource {
    type   = each.value.monitored_resource.type
    labels = each.value.monitored_resource.labels
  }
}

resource "google_monitoring_alert_policy" "this" {
  for_each = var.alert_policies

  project      = var.project_id
  display_name = each.key
  combiner     = try(each.value.combiner, "OR")
  enabled      = try(each.value.enabled, true)

  notification_channels = try(each.value.notification_channels, [])

  dynamic "conditions" {
    for_each = try(each.value.conditions, [])
    content {
      display_name = conditions.value.display_name

      dynamic "condition_threshold" {
        for_each = try([conditions.value.condition_threshold], [])
        content {
          filter          = condition_threshold.value.filter
          comparison      = condition_threshold.value.comparison
          duration        = condition_threshold.value.duration
          threshold_value = try(condition_threshold.value.threshold_value, null)
          dynamic "aggregations" {
            for_each = try(condition_threshold.value.aggregations, [])
            content {
              alignment_period   = aggregations.value.alignment_period
              per_series_aligner = try(aggregations.value.per_series_aligner, null)
            }
          }
        }
      }
    }
  }

  dynamic "alert_strategy" {
    for_each = try([each.value.alert_strategy], [])
    content {
      auto_close = try(alert_strategy.value.auto_close, null)
    }
  }

  documentation {
    content = try(each.value.documentation, "")
  }
}
