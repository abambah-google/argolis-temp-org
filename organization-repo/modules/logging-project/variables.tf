# Copyright 2024 Google LLC

variable "organization_id" {
  type        = string
  description = "The GCP organization ID."
}

variable "billing_account" {
  type        = string
  description = "The billing account ID to associate with the logging project."
}

variable "folder_id" {
  type        = string
  description = "The folder ID to create the logging project under."
}

variable "logging_project_id" {
  type        = string
  description = "The globally unique project ID for the dedicated logging project."
  default     = "c3-ai-logging-project"
}

variable "region" {
  type        = string
  description = "The GCP region for the log archive bucket."
  default     = "us-central1"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days after which logs in GCS are transitioned to COLDLINE storage."
  default     = 30
}

variable "log_archive_delete_days" {
  type        = number
  description = "Number of days after which log objects are deleted from GCS."
  default     = 365
}

variable "log_sink_filter" {
  type        = string
  description = "Log sink filter for the GCS sink. Defaults to all logs."
  default     = ""
}

variable "bq_log_sink_filter" {
  type        = string
  description = <<-EOT
    Log sink filter for the BigQuery sink.
    Defaults to security-relevant log types to control cost.
  EOT
  default     = <<-EOT
    log_id("cloudaudit.googleapis.com/activity") OR
    log_id("cloudaudit.googleapis.com/data_access") OR
    log_id("cloudaudit.googleapis.com/system_event") OR
    log_id("cloudaudit.googleapis.com/policy") OR
    severity >= WARNING
  EOT
}
