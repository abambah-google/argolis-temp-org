#!/bin/bash
set -euo pipefail

# Description: Bootstrap script — sets up the Terraform service account, GCS state bucket,
#              and runs both the organization-repo and project-repo deployments.
#
# Prerequisites:
#   - gcloud CLI authenticated with an account that has Organization Admin + Billing Admin
#   - Terraform >= 1.5 installed and on PATH
#
# Usage:
#   1. Fill in the USER-CONFIGURABLE VARIABLES section below.
#   2. chmod +x startup2.bash
#   3. ./startup2.bash

# =============================================================================
# USER-CONFIGURABLE VARIABLES — edit these before running
# =============================================================================

# Numeric GCP Organization ID (run: gcloud organizations list)
export TF_VAR_org_id="564880270938"

# Billing account ID (run: gcloud billing accounts list)
# export TF_VAR_billing_account="01A32C-6BC104-24563F"
export TF_VAR_billing_account="01A32C-6BC104-24563F"
# Host / Shared VPC project ID (must be globally unique)
export TF_VAR_host_project="tf-ai-host-project5"

# Folder that already exists under your org (folder display name or numeric ID)
export TF_VAR_demo_folder_name="${TF_VAR_org_id}-demo-folder-name"

# Dedicated logging project ID (must be globally unique)
export TF_VAR_logging_project_id="${TF_VAR_org_id}-logging-project"

# Workforce Identity Pool settings
export TF_VAR_workforce_pool_id="a-${TF_VAR_org_id}-corp-workforce-pool"
export TF_VAR_workforce_provider_id="a-${TF_VAR_org_id}-corp-idp-provider"
# Set to your OIDC issuer URI (e.g. https://login.your-org.com)
export TF_VAR_oidc_issuer_uri="https://googlenasc.okta.com"
export TF_VAR_oidc_client_id="0oavmp8kfhThsaFwC4x7"
export TF_VAR_oidc_client_secret="GGGmZJZRI4fGfigQzVtwKH5xIc6FsfYLt-gVM0ivGDEi8gJrQ2-2EKkQ5NYmv8ZF"

# Security Command Center
export TF_VAR_scc_notification_name="${TF_VAR_org_id}org-scc-notifications"
export TF_VAR_scc_pubsub_topic_name="${TF_VAR_org_id}scc-findings-topic"

# Terraform state project + service account
export SERVICE_ACCOUNT_NAME="terraform-org-admin"
export TERRAFORM_STATE_PROJECT_ID="${TF_VAR_host_project}-tf-state"
export TF_CREDS="terraform-credentials.json"

# =============================================================================
# Derived variables (do not edit)
# =============================================================================
export SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${TERRAFORM_STATE_PROJECT_ID}.iam.gserviceaccount.com"
export BUCKET_NAME="${TERRAFORM_STATE_PROJECT_ID}-tfstate"

export TF_VAR_consumer_project_a_id="consumer-proj-a-$(tr -dc 'a-z0-9' </dev/urandom | head -c 6)"
export TF_VAR_consumer_project_b_id="consumer-proj-b-$(tr -dc 'a-z0-9' </dev/urandom | head -c 6)"
export TF_VAR_cloud_storage_bucket_name="${TERRAFORM_STATE_PROJECT_ID}-tfstate-bkt"

# =============================================================================
# 1. Terraform state project
# =============================================================================
echo ">>> [1/7] Ensuring Terraform state project: ${TERRAFORM_STATE_PROJECT_ID}"
if ! gcloud projects describe "${TERRAFORM_STATE_PROJECT_ID}" >/dev/null 2>&1; then
  echo "    Creating project ${TERRAFORM_STATE_PROJECT_ID}..."
  gcloud projects create "${TERRAFORM_STATE_PROJECT_ID}" \
    --organization="${TF_VAR_org_id}"
else
  echo "    Project already exists."
fi

echo "    Linking to billing account..."
gcloud billing projects link "${TERRAFORM_STATE_PROJECT_ID}" \
  --billing-account="${TF_VAR_billing_account}"

# =============================================================================
# 2. Enable bootstrap APIs
# =============================================================================
echo ">>> [2/7] Enabling required APIs on state project..."
gcloud services enable \
  cloudresourcemanager.googleapis.com \
  cloudbilling.googleapis.com \
  iam.googleapis.com \
  iamcredentials.googleapis.com \
  compute.googleapis.com \
  serviceusage.googleapis.com \
  cloudidentity.googleapis.com \
  storage-api.googleapis.com \
  logging.googleapis.com \
  securitycenter.googleapis.com \
  pubsub.googleapis.com \
  orgpolicy.googleapis.com \
  iam.googleapis.com \
  --project="${TERRAFORM_STATE_PROJECT_ID}"

# =============================================================================
# 3. Service account
# =============================================================================
echo ">>> [3/7] Ensuring Terraform service account: ${SERVICE_ACCOUNT_EMAIL}"
if ! gcloud iam service-accounts describe "${SERVICE_ACCOUNT_EMAIL}" --project="${TERRAFORM_STATE_PROJECT_ID}" >/dev/null 2>&1; then
  echo "    Creating service account ${SERVICE_ACCOUNT_NAME}..."
  gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}" \
    --display-name="Terraform Organization Admin" \
    --project="${TERRAFORM_STATE_PROJECT_ID}"
  echo "    Waiting for service account propagation..."
  sleep 30
else
  echo "    Service account already exists."
fi



# =============================================================================
# 4. IAM roles for the Terraform service account
# =============================================================================
echo ">>> [4/7] Granting IAM roles to service account..."
# APP_SERVICE_ACCOUNT_EMAIL="cloud-environments.google.com@appspot.gserviceaccount.com"

# Organization-level roles needed for org-repo
ORG_ROLES=(
  "roles/owner"
  "roles/resourcemanager.organizationAdmin"
  "roles/billing.admin"
  "roles/orgpolicy.policyAdmin"
  "roles/iam.organizationRoleAdmin"
  "roles/iam.workloadIdentityPoolAdmin"
  "roles/iam.workforcePoolAdmin"
  "roles/securitycenter.admin"
  "roles/logging.admin"
  "roles/resourcemanager.folderAdmin"
)
for ROLE in "${ORG_ROLES[@]}"; do
  echo "    Binding ${ROLE} at org level..."
  gcloud organizations add-iam-policy-binding "${TF_VAR_org_id}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="${ROLE}" \
    --condition=None \
    --quiet

  # gcloud organizations add-iam-policy-binding "${TF_VAR_org_id}" \
  #   --member="serviceAccount:${APP_SERVICE_ACCOUNT_EMAIL}" \
  #   --role="${ROLE}" \
  #   --condition=None \
  #   --quiet
done

# Grant Token Creator role to the current user on the state project
# This is required for service account impersonation.
CURRENT_USER=$(gcloud config get-value account 2>/dev/null)
echo "    Granting Token Creator role to ${CURRENT_USER} on state project..."
gcloud projects add-iam-policy-binding "${TERRAFORM_STATE_PROJECT_ID}" \
    --member="user:${CURRENT_USER}" \
    --role="roles/iam.serviceAccountTokenCreator" \
    --quiet

# Project-level role on the state project for GCS state management
gcloud projects add-iam-policy-binding "${TERRAFORM_STATE_PROJECT_ID}" \
  --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
  --role="roles/storage.admin" \
  --quiet

echo "    Waiting 60s for role propagation across Organization..."
sleep 60


# COMMENTED OUT: This requires orgpolicy.policyAdmin which the caller may not have.
# Since we are not generating SA keys, this is not strictly needed.
# gcloud resource-manager org-policies delete \
#     iam.disableServiceAccountKeyCreation \
#     --project="${TERRAFORM_STATE_PROJECT_ID}"


# Only create a new key if the credentials file does not already exist
# =============================================================================
# 5. GCS Terraform state bucket
# =============================================================================
echo ">>> [5/7] Ensuring GCS state bucket: gs://${BUCKET_NAME}"
if ! gcloud storage buckets describe "gs://${BUCKET_NAME}" >/dev/null 2>&1; then
  echo "    Creating bucket..."
  gcloud storage buckets create "gs://${BUCKET_NAME}" \
    --project="${TERRAFORM_STATE_PROJECT_ID}" \
    --uniform-bucket-level-access 
else
  echo "    Bucket already exists."
fi

# =============================================================================
# 6. Activate service account for Terraform
# =============================================================================
# sleep 30
if ! gcloud auth application-default print-access-token >/dev/null 2>&1; then
  echo "    No valid Application Default Credentials found. Please log in..."
  gcloud auth application-default login --disable-quota-project
else
  echo "    Using existing Application Default Credentials (e.g., from Cloud Shell)..."
fi
# if [[ ! -f "${TF_CREDS}" ]]; then
#   echo "    Generating service account key → ${TF_CREDS}"
#   gcloud iam service-accounts keys create "${TF_CREDS}" \
#     --iam-account="${SERVICE_ACCOUNT_EMAIL}" \
#     --project="${TERRAFORM_STATE_PROJECT_ID}"
# else
#   echo "    Credentials file already exists, skipping key generation."
# fi

# chmod 777 ${TF_CREDS}
# echo ">>> [6/7] Activating service account credentials..."
# gcloud auth activate-service-account --key-file="${TF_CREDS}"
# export GOOGLE_APPLICATION_CREDENTIALS="${TF_CREDS}"
# export GOOGLE_PROJECT="${TERRAFORM_STATE_PROJECT_ID}"
# export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT="${SERVICE_ACCOUNT_EMAIL}"

# =============================================================================
# 7. Terraform — organization-repo
# =============================================================================
echo ">>> [7a/7] Running Terraform: organization-repo"
cd organization-repo

# Enable impersonation for Terraform
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT="${SERVICE_ACCOUNT_EMAIL}"

echo "    Writing backend.tf..."
cat > backend.tf << EOF
terraform {
  backend "gcs" {
    bucket = "${BUCKET_NAME}"
    prefix = "terraform/org-state"
  }
}
EOF

echo "    Writing terraform.tfvars..."
cat > terraform.tfvars << EOF
organization_id   = "${TF_VAR_org_id}"
billing_account   = "${TF_VAR_billing_account}"
host-project-name = "${TF_VAR_host_project}"
demo_folder_name  = "${TF_VAR_demo_folder_name}"

# Logging project
logging_project_id = "${TF_VAR_logging_project_id}"

# Workforce Identity
workforce_pool_id           = "${TF_VAR_workforce_pool_id}"
workforce_provider_id       = "${TF_VAR_workforce_provider_id}"
idp_type                    = "oidc"
oidc_issuer_uri             = "${TF_VAR_oidc_issuer_uri}"
oidc_client_id              = "${TF_VAR_oidc_client_id}"
oidc_client_secret          = "${TF_VAR_oidc_client_secret}"

# Security Command Center
scc_notification_name = "${TF_VAR_scc_notification_name}"
scc_pubsub_topic_name = "${TF_VAR_scc_pubsub_topic_name}"

# Org policy domain restriction — set to your Cloud Identity customer ID(s)
# e.g. allowed_policy_domains = ["C0abc1234"]
allowed_policy_domains           = []
allowed_shared_vpc_host_projects = []
EOF

echo "    Initializing Terraform..."
terraform init

echo "    Checking for existing resources to import..."
# Import Workforce Pool if it exists
if gcloud iam workforce-pools describe "${TF_VAR_workforce_pool_id}" --location=global --quiet >/dev/null 2>&1; then
  echo "    Importing existing workforce pool..."
  terraform import module.workforce-identity.google_iam_workforce_pool.pool "locations/global/workforcePools/${TF_VAR_workforce_pool_id}" || true
fi

# Import Org Policy if it exists
if gcloud resource-manager org-policies describe iam.disableServiceAccountKeyCreation --organization="${TF_VAR_org_id}" --format='value(name)' --quiet >/dev/null 2>&1; then
  echo "    Importing existing Org Policy..."
  terraform import module.org-policies.google_org_policy_policy.disable_sa_key_creation "organizations/${TF_VAR_org_id}/policies/iam.disableServiceAccountKeyCreation" || true
fi

# echo "    Importing existing org policies to state..."
# ./import_org_policies.sh

echo "    Applying Terraform plan..."
terraform apply -auto-approve -var-file=terraform.tfvars

# =============================================================================
# 7. Terraform — project-repo
# =============================================================================
echo ">>> [7b/7] Running Terraform: project-repo"
cd ../project-repo

echo "    Writing backend.tf..."
cat > backend.tf << EOF
terraform {
  backend "gcs" {
    bucket = "${BUCKET_NAME}"
    prefix = "terraform/project-state"
  }
}
EOF

echo "    Writing terraform.tfvars..."
cat > terraform.tfvars << EOF
organization_id              = "${TF_VAR_org_id}"
billing_account              = "${TF_VAR_billing_account}"
host-project-name            = "${TF_VAR_host_project}"
demo_folder_name             = "${TF_VAR_demo_folder_name}"
consumer_project_a_id        = "${TF_VAR_consumer_project_a_id}"
consumer_project_b_id        = "${TF_VAR_consumer_project_b_id}"
cloud_storage_bucket_name    = "${TF_VAR_cloud_storage_bucket_name}"
create_default_access_policy = true
EOF

echo "    Initializing Terraform..."
terraform init

echo "    Applying Terraform plan..."
terraform apply -auto-approve -var-file=terraform.tfvars

echo ""
echo "========================================"
echo "  Bootstrap and Terraform apply complete"
echo "========================================"