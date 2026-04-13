# Copyright 2024 Google LLC
# Author: abambah@google.com
# Module: logging-project
# Creates a dedicated logging project with an org-level log sink → GCS bucket.

# -----------------------------------------------------------------------
# Logging Project
# -----------------------------------------------------------------------
module "logging-project-factory" {
  source = "terraform-google-modules/project-factory/google"
  # version = "~> 15.0"

  project_id                  = var.logging_project_id
  name                        = var.logging_project_id
  folder_id                   = var.folder_id
  org_id                      = var.organization_id
  billing_account             = var.billing_account
  random_project_id           = false
  disable_services_on_destroy = false

  activate_apis = [
    "logging.googleapis.com",
    "storage.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "pubsub.googleapis.com",
    "monitoring.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}

# -----------------------------------------------------------------------
# GCS Bucket — long-term log archive in the logging project
# -----------------------------------------------------------------------
resource "google_storage_bucket" "log_archive" {
  project                     = module.logging-project-factory.project_id
  name                        = "${var.logging_project_id}-log-archive"
  location                    = upper(var.region)
  storage_class               = "NEARLINE"
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = var.log_retention_days
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = var.log_archive_delete_days
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [module.logging-project-factory]
}

# -----------------------------------------------------------------------
# Organization-level aggregated log sink
# -----------------------------------------------------------------------
resource "google_logging_organization_sink" "org_log_sink" {
  name             = "${var.logging_project_id}-org-sink"
  org_id           = var.organization_id
  include_children = true
  destination      = "storage.googleapis.com/${google_storage_bucket.log_archive.name}"

  # Capture all log types — adjust filter to reduce volume/cost if needed
  filter = var.log_sink_filter

  depends_on = [google_storage_bucket.log_archive]
}

# -----------------------------------------------------------------------
# Grant the sink's writer identity access to write to the bucket
# -----------------------------------------------------------------------
resource "google_storage_bucket_iam_member" "log_sink_writer" {
  bucket = google_storage_bucket.log_archive.name
  role   = "roles/storage.objectCreator"
  member = google_logging_organization_sink.org_log_sink.writer_identity
}

# -----------------------------------------------------------------------
# BigQuery dataset for advanced log analytics (optional, always created)
# -----------------------------------------------------------------------
resource "google_bigquery_dataset" "log_analytics" {
  project                    = module.logging-project-factory.project_id
  dataset_id                 = "org_log_analytics"
  friendly_name              = "Org Log Analytics"
  description                = "BigQuery dataset for organization-level log analytics"
  location                   = upper(var.region)
  delete_contents_on_destroy = false

  depends_on = [module.logging-project-factory]
}

# -----------------------------------------------------------------------
# BigQuery log sink (secondary sink for real-time analytics)
# -----------------------------------------------------------------------
resource "google_logging_organization_sink" "org_bq_sink" {
  name             = "${var.logging_project_id}-org-bq-sink"
  org_id           = var.organization_id
  include_children = true
  destination      = "bigquery.googleapis.com/projects/${module.logging-project-factory.project_id}/datasets/${google_bigquery_dataset.log_analytics.dataset_id}"

  # Only route security-relevant logs to BQ for cost control
  filter = var.bq_log_sink_filter

  bigquery_options {
    use_partitioned_tables = true
  }

  depends_on = [google_bigquery_dataset.log_analytics]
}

resource "google_bigquery_dataset_iam_member" "bq_log_sink_writer" {
  project    = module.logging-project-factory.project_id
  dataset_id = google_bigquery_dataset.log_analytics.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_organization_sink.org_bq_sink.writer_identity
}
