variable "organization_id" {
  type        = string
  description = "organization id required"
}
variable "billing_account" {
  type        = string
  description = "billing account required"
}
variable "demo_folder_name" {
  type        = string
  description = "unique name of demo folder to be created"
}
variable "region1" {
  type    = string
  default = "us-east1"
}
variable "region2" {
  type    = string
  default = "us-west1"
}
variable "host-project-name" {
  type    = string
  default = "host-project"
}

variable "consumer_project_a_id" {
  type        = string
  description = "globally unique id of consumer project a to be created"
}

variable "consumer_project_b_id" {
  type        = string
  description = "globally unique id of consumer project b to be created"
}

# ------------------------------------------------------------------
# Org Policies
# ------------------------------------------------------------------
variable "allowed_policy_domains" {
  type        = list(string)
  description = "Cloud Identity customer IDs allowed as IAM policy members (e.g. [\"C0abc1234\"]). Leave empty to skip domain restriction."
  default     = []
}

variable "allowed_shared_vpc_host_projects" {
  type        = list(string)
  description = "Allowed Shared VPC host project resource names (e.g. [\"projects/123456789\"]. Leave empty to skip this policy."
  default     = []
}

# ------------------------------------------------------------------
# Workforce Identity + SCIM
# ------------------------------------------------------------------
variable "workforce_pool_id" {
  type        = string
  description = "ID for the Workforce Identity Pool (4-32 lowercase alphanumeric or hyphens)."
  default     = "corp-workforce-pool"
}

variable "workforce_pool_display_name" {
  type        = string
  description = "Display name for the Workforce Identity Pool."
  default     = "Corporate Workforce Pool"
}

variable "workforce_provider_id" {
  type        = string
  description = "ID for the Workforce Identity Pool provider."
  default     = "corp-idp-provider"
}

variable "idp_type" {
  type        = string
  description = "IdP protocol type: 'oidc' or 'saml'."
  default     = "oidc"
}

variable "oidc_issuer_uri" {
  type        = string
  description = "OIDC issuer URI  Required when idp_type = 'oidc'."
  default     = "https://googlenasc.okta.com"
}

variable "oidc_client_id" {
  type        = string
  description = "OIDC client ID for the workforce pool provider. Required when idp_type = 'oidc'."
  default     = "0oavmp8kfhThsaFwC4x7"
}

variable "oidc_client_secret" {
  type        = string
  description = "OIDC client secret for the workforce pool provider. Required when idp_type = 'oidc'."
  default     = "GGGmZJZRI4fGfigQzVtwKH5xIc6FsfYLt-gVM0ivGDEi8gJrQ2-2EKkQ5NYmv8ZF"
}

variable "saml_idp_metadata_xml" {
  type        = string
  description = "Raw SAML IdP metadata XML. Required when idp_type = 'saml'."
  default     = ""
}

variable "session_duration" {
  type        = string
  description = "Workforce pool token session duration (e.g. '3600s')."
  default     = "3600s"
}

# ------------------------------------------------------------------
# Logging Project
# ------------------------------------------------------------------
variable "logging_project_id" {
  type        = string
  description = "Globally unique project ID for the dedicated logging project."
  default     = "c3-ai-logging-project"
}

variable "log_retention_days" {
  type        = number
  description = "Days before GCS log objects transition to COLDLINE storage."
  default     = 30
}

# ------------------------------------------------------------------
# Security Command Center
# ------------------------------------------------------------------
variable "scc_notification_name" {
  type        = string
  description = "Name for the SCC notification config."
  default     = "org-scc-notifications"
}

variable "scc_pubsub_topic_name" {
  type        = string
  description = "Name of the Pub/Sub topic to receive SCC finding notifications."
  default     = "scc-findings-topic"
}
