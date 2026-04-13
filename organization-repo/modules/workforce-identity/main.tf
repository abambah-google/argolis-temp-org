# Copyright 2026 Google LLC
# Author: abambah@google.com
# Module: workforce-identity
# Creates a Workforce Identity Pool and OIDC/SAML provider for external IdP federation.
# The SCIM provisioning endpoint is an output — wire it into your IdP's SCIM settings.

resource "google_iam_workforce_pool" "pool" {
  workforce_pool_id = var.workforce_pool_id
  parent            = "organizations/${var.organization_id}"
  display_name      = var.workforce_pool_display_name
  description       = "Workforce Identity Pool for external IdP federation and SCIM provisioning"
  session_duration  = var.session_duration
  location          = "global"

  # SCIM provisioning is automatically enabled on the pool.
  # The SCIM endpoint URL and provisioning token are available as outputs.
}

# OIDC provider (e.g. Okta, Azure AD, Ping via OIDC)
resource "google_iam_workforce_pool_provider" "oidc_provider" {
  count             = var.idp_type == "oidc" ? 1 : 0
  workforce_pool_id = google_iam_workforce_pool.pool.workforce_pool_id
  provider_id       = var.workforce_provider_id
  # parent                 = "organizations/${var.organization_id}"
  display_name = substr("${var.workforce_pool_display_name} OIDC Provider", 0, 32)
  description  = "OIDC provider for ${var.workforce_pool_display_name}"
  disabled     = false
  location     = "global"

  attribute_mapping = var.oidc_attribute_mapping

  oidc {
    issuer_uri = var.oidc_issuer_uri
    client_id  = var.oidc_client_id

    client_secret {
      value {
        plain_text = var.oidc_client_secret
      }
    }

    web_sso_config {
      response_type             = "CODE"
      assertion_claims_behavior = "MERGE_USER_INFO_OVER_ID_TOKEN_CLAIMS"
    }
  }
}

# # SAML provider (e.g. Okta SAML, ADFS, Ping SAML)
# resource "google_iam_workforce_pool_provider" "saml_provider" {
#   count             = var.idp_type == "saml" ? 1 : 0
#   workforce_pool_id = google_iam_workforce_pool.pool.workforce_pool_id
#   provider_id       = var.workforce_provider_id
#   # parent                 = "organizations/${var.organization_id}"
#   display_name = substr("${var.workforce_pool_display_name} SAML Provider", 0, 32)
#   description  = "SAML provider for ${var.workforce_pool_display_name}"
#   disabled     = false
#   location     = "global"

#   attribute_mapping = {
#     "google.subject"      = "assertion.subject"
#     "google.display_name" = "assertion.attributes.displayName[0]"
#     "google.groups"       = "assertion.attributes.groups"
#     "attribute.email"     = "assertion.attributes.email[0]"
#   }

#   saml {
#     idp_metadata_xml = var.saml_idp_metadata_xml
#   }
# }
