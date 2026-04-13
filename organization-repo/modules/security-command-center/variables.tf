# Copyright 2024 Google LLC

variable "organization_id" {
  type        = string
  description = "The GCP organization ID."
}

variable "project_id" {
  type        = string
  description = "The project ID where SCC Pub/Sub resources will be created (typically the host project)."
}

variable "scc_notification_name" {
  type        = string
  description = "The name/ID of the SCC notification config."
  default     = "org-scc-notifications"
}

variable "pubsub_topic_name" {
  type        = string
  description = "The name of the Pub/Sub topic that will receive SCC finding notifications."
  default     = "scc-findings-topic"
}

variable "scc_findings_filter" {
  type        = string
  description = "SCC streaming filter. Defaults to all active findings."
  default     = "state = \"ACTIVE\""
}

variable "create_custom_scc_source" {
  type        = bool
  description = "Whether to create a custom SCC finding source."
  default     = false
}

variable "custom_source_display_name" {
  type        = string
  description = "Display name for the custom SCC finding source. Only used if create_custom_scc_source = true."
  default     = "Custom Security Findings"
}
