# Copyright 2024 Google LLC
# Author: abambah@google.com
# Module: security-command-center
# Enables SCC and configures notifications for findings via Pub/Sub.

# -----------------------------------------------------------------------
# Enable required APIs in the host project (where Pub/Sub will live)
# -----------------------------------------------------------------------
resource "google_project_service" "scc_api" {
  project                    = var.project_id
  service                    = "securitycenter.googleapis.com"
  disable_dependent_services = false
}

resource "google_project_service" "scc_management_api" {
  project                    = var.project_id
  service                    = "securitycentermanagement.googleapis.com"
  disable_dependent_services = false
}

resource "google_project_service" "pubsub_scc" {
  project                    = var.project_id
  service                    = "pubsub.googleapis.com"
  disable_dependent_services = false
}

# -----------------------------------------------------------------------
# Pub/Sub topic to receive SCC finding notifications
# -----------------------------------------------------------------------
resource "google_pubsub_topic" "scc_findings" {
  project = var.project_id
  name    = var.pubsub_topic_name

  message_retention_duration = "86600s" # ~24 hours

  depends_on = [google_project_service.pubsub_scc]
}

# Grant SCC service account permission to publish to the topic
resource "google_pubsub_topic_iam_member" "scc_publisher" {
  project = var.project_id
  topic   = google_pubsub_topic.scc_findings.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-org-${var.organization_id}@gcp-sa-scc.iam.gserviceaccount.com"
}

# -----------------------------------------------------------------------
# SCC Notification Config — streams all ACTIVE findings to Pub/Sub
# -----------------------------------------------------------------------
resource "google_scc_notification_config" "scc_notifications" {
  config_id    = var.scc_notification_name
  organization = var.organization_id
  description  = "Organization-wide SCC findings streamed to Pub/Sub"
  pubsub_topic = google_pubsub_topic.scc_findings.id

  streaming_config {
    # Capture all active (open) findings — narrow filter here to reduce volume
    filter = var.scc_findings_filter
  }

  depends_on = [
    google_pubsub_topic.scc_findings,
    google_project_service.scc_api,
  ]
}

# -----------------------------------------------------------------------
# Pub/Sub Subscription — allows consumers to pull SCC findings
# -----------------------------------------------------------------------
resource "google_pubsub_subscription" "scc_findings_sub" {
  project = var.project_id
  name    = "${var.pubsub_topic_name}-sub"
  topic   = google_pubsub_topic.scc_findings.name

  ack_deadline_seconds       = 60
  message_retention_duration = "604800s" # 7 days
  retain_acked_messages      = false

  expiration_policy {
    ttl = "" # Never expire
  }

  depends_on = [google_pubsub_topic.scc_findings]
}

# -----------------------------------------------------------------------
# Optional: SCC Source — registers a custom finding source for this org
# -----------------------------------------------------------------------
resource "google_scc_source" "custom_source" {
  count        = var.create_custom_scc_source ? 1 : 0
  display_name = var.custom_source_display_name
  organization = var.organization_id
  description  = "Custom SCC finding source managed by Terraform"
}
