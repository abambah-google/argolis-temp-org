# Copyright 2024 Google LLC

output "pubsub_topic_id" {
  description = "The ID of the Pub/Sub topic receiving SCC findings."
  value       = google_pubsub_topic.scc_findings.id
}

output "pubsub_subscription_id" {
  description = "The ID of the Pub/Sub subscription for SCC findings."
  value       = google_pubsub_subscription.scc_findings_sub.id
}

output "notification_config_name" {
  description = "The full resource name of the SCC notification config."
  value       = google_scc_notification_config.scc_notifications.name
}
