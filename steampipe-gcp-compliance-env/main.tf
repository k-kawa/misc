data "google_monitoring_notification_channel" "me" {
  project = var.project_id
  display_name = var.notification_channel_display_name
}

locals {
  audit_config_yaml = yamldecode(file("audit_config.yaml"))
}

resource "google_logging_metric" "audit_metric" {
  for_each = local.audit_config_yaml.audits

  project = var.project_id
  name = each.value.logging_metric_name
  filter = each.value.logging_metric_filter
}

resource "google_monitoring_alert_policy" "audit_alert" {
  for_each = local.audit_config_yaml.audits

  project = var.project_id
  display_name = each.value.alert_policy_display_name 
  notification_channels = [ data.google_monitoring_notification_channel.me.name ]

  conditions {
    display_name = each.value.logging_metric_name
    condition_threshold {
      aggregations {
        alignment_period = "300s"
        cross_series_reducer = "REDUCE_SUM"
        per_series_aligner = "ALIGN_COUNT"
      }
      comparison = "COMPARISON_GT"
      duration = "0s"
      filter = "resource.type=\"${lookup(each.value, "alert_policy_resource_type", "global")}\" AND metric.type=\"logging.googleapis.com/user/${each.value.logging_metric_name}\""
      trigger {
        count = 1
      }
    }
  }
  combiner = "OR"
}

