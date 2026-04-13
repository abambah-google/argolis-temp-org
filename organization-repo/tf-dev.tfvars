organization_id   = "579419163830"
billing_account   = "01A32C-6BC104-24563F"
host-project-name = "c3-ai-host-project"
demo_folder_name  = "579419163830-demo-folder-name"
region1           = "us-central1"
region2           = "us-west1"

# ------------------------------------------------------------------
# Org Policies
# ------------------------------------------------------------------
# Add your Cloud Identity customer IDs here to restrict IAM member domains.
# Leave empty to skip domain restriction.
# Example: allowed_policy_domains = ["C0abc1234"]
allowed_policy_domains = []

# Add host project resource names to restrict Shared VPC.
# Example: allowed_shared_vpc_host_projects = ["projects/123456789012"]
allowed_shared_vpc_host_projects = []

# ------------------------------------------------------------------
# Workforce Identity + SCIM
# ------------------------------------------------------------------
workforce_pool_id           = "corp-workforce-pool"
workforce_pool_display_name = "Corporate Workforce Pool"
workforce_provider_id       = "corp-idp-provider"

# Set to "oidc" or "saml"
idp_type = "oidc"

# Fill in your OIDC IdP details (e.g. Okta, Azure AD)
oidc_issuer_uri = "https://YOUR_IDP.example.com"
oidc_client_id  = "YOUR_CLIENT_ID"

# For SAML only — paste full IdP metadata XML
# saml_idp_metadata_xml = ""

session_duration = "3600s"

# ------------------------------------------------------------------
# Logging Project
# ------------------------------------------------------------------
logging_project_id = "c3-ai-logging-project"
log_retention_days = 30

# ------------------------------------------------------------------
# Security Command Center
# ------------------------------------------------------------------
scc_notification_name = "org-scc-notifications"
scc_pubsub_topic_name = "scc-findings-topic"
