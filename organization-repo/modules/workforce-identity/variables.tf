# Copyright 2024 Google LLC

variable "organization_id" {
  type        = string
  description = "The GCP organization ID."
}

variable "workforce_pool_id" {
  type        = string
  description = "The ID for the Workforce Identity Pool. Must be 4-32 lowercase letters, digits, or hyphens."
  default     = "corp-workforce-pool"
}

variable "workforce_pool_display_name" {
  type        = string
  description = "Display name for the Workforce Identity Pool."
  default     = "Corporate Workforce Pool"
}

variable "workforce_provider_id" {
  type        = string
  description = "The ID for the Workforce Identity Pool provider."
  default     = "corp-idp-provider"
}

variable "session_duration" {
  type        = string
  description = "Session duration for workforce pool tokens. Format: '<seconds>s'. Default: 3600s (1 hour)."
  default     = "3600s"
}

variable "idp_type" {
  type        = string
  description = "Type of IdP to create a provider for. Must be 'oidc' or 'saml'."
  default     = "oidc"
  validation {
    condition     = contains(["oidc", "saml"], var.idp_type)
    error_message = "idp_type must be either 'oidc' or 'saml'."
  }
}

# OIDC-specific variables
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

variable "oidc_attribute_mapping" {
  type        = map(string)
  description = "Attribute mapping for OIDC provider."
  default = {
    "google.subject"      = "assertion.sub"
    "google.display_name" = "assertion.name"
    "google.groups"       = "assertion.groups"
    "attribute.email"     = "assertion.email"
  }
}

variable "oidc_client_secret" {
  type        = string
  description = "OIDC client secret for the workforce pool provider. Required when idp_type = 'oidc'."
  default     = "GGGmZJZRI4fGfigQzVtwKH5xIc6FsfYLt-gVM0ivGDEi8gJrQ2-2EKkQ5NYmv8ZF"
}

# SAML-specific variables
variable "saml_idp_metadata_xml" {
  type        = string
  description = "Full SAML IdP metadata XML string. Required when idp_type = 'saml'."
  default     = ""
}

variable "location" {
  type    = string
  default = "us-central1"

}


