# Copyright 2024 Google LLC

output "workforce_pool_name" {
  description = "The full resource name of the Workforce Identity Pool."
  value       = google_iam_workforce_pool.pool.name
}

output "workforce_pool_id" {
  description = "The ID of the Workforce Identity Pool."
  value       = google_iam_workforce_pool.pool.workforce_pool_id
}

output "scim_endpoint_uri" {
  description = <<-EOT
    The SCIM 2.0 provisioning endpoint URL for this pool.
    Configure this as the SCIM endpoint in your IdP (e.g. Okta, Azure AD).
    Format: https://iam.googleapis.com/v1/locations/global/workforcePools/<POOL_ID>/subjects
    Your IdP will use: https://cloudidentity.googleapis.com/v1/workforcePools/<POOL_ID>:importUsers
  EOT
  value       = "https://iam.googleapis.com/v1/locations/global/workforcePools/${google_iam_workforce_pool.pool.workforce_pool_id}/subjects"
}

output "provider_name" {
  description = "The full resource name of the created provider (OIDC or SAML)."
  value       = length(google_iam_workforce_pool_provider.oidc_provider) > 0 ? google_iam_workforce_pool_provider.oidc_provider[0].name : null
}
