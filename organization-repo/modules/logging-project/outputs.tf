# Copyright 2024 Google LLC

output "logging_project_id" {
  description = "The project ID of the dedicated logging project."
  value       = module.logging-project-factory.project_id
}

output "log_bucket_name" {
  description = "The name of the GCS bucket used for log archival."
  value       = google_storage_bucket.log_archive.name
}

output "gcs_sink_writer_identity" {
  description = "The writer identity of the GCS org log sink. Grant this identity objectCreator on your bucket if using a custom bucket."
  value       = google_logging_organization_sink.org_log_sink.writer_identity
}

output "bq_sink_writer_identity" {
  description = "The writer identity of the BigQuery org log sink."
  value       = google_logging_organization_sink.org_bq_sink.writer_identity
}

output "bq_dataset_id" {
  description = "The BigQuery dataset ID for log analytics."
  value       = google_bigquery_dataset.log_analytics.dataset_id
}
