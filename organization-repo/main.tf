# Copyright 2024 Google LLC
# Author: abambah@google.com

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

provider "google" {}

provider "google-beta" {}

/* As per the requirements we will be provided with the folder that is already created.
resource "google_folder" "terraform_demo" {
  display_name = var.demo_folder_name
  parent       = "organizations/${var.organization_id}"
}
*/

# -----------------------------------------------------------------------
# Host Project — creates the Shared VPC host project with GKE and VPC
# -----------------------------------------------------------------------
module "hostproject" {
  source            = "./modules/hostproject"
#   folder_id         = var.demo_folder_name
  project_id        = var.host-project-name
  billing_account   = var.billing_account
  host_project_name = var.host-project-name
  organization_id   = var.organization_id
  region1           = var.region1
  region2           = var.region2
}

# -----------------------------------------------------------------------
# IAM Bindings — project-level service account role bindings
# -----------------------------------------------------------------------
module "iam-bindings" {
  source           = "./modules/iam-bindings"
  project_id       = module.hostproject.project_id
  custom_sa_emails = module.hostproject.custom_sa_emails
  custom_sa_ids    = module.hostproject.custom_sa_ids
  additional_service_accounts = [
    "default-gce@${var.consumer_project_a_id}.iam.gserviceaccount.com",
    "default-gke@${var.consumer_project_a_id}.iam.gserviceaccount.com",
    "default-apps@${var.consumer_project_a_id}.iam.gserviceaccount.com",
    "bastion@${var.consumer_project_a_id}.iam.gserviceaccount.com",
    "ops-admin@${var.consumer_project_a_id}.iam.gserviceaccount.com",
    "auto-admin@${var.consumer_project_a_id}.iam.gserviceaccount.com",
    "builds@${var.consumer_project_a_id}.iam.gserviceaccount.com",
    "events@${var.consumer_project_a_id}.iam.gserviceaccount.com",
    "dns-admin@${var.consumer_project_a_id}.iam.gserviceaccount.com"
  ]
  depends_on = [module.hostproject]
}

# -----------------------------------------------------------------------
# Organization Policies — enforce security guardrails org-wide
# -----------------------------------------------------------------------
module "org-policies" {
  source                           = "./modules/org-policies"
  organization_id                  = var.organization_id
  allowed_policy_domains           = var.allowed_policy_domains
  allowed_shared_vpc_host_projects = var.allowed_shared_vpc_host_projects
}

# # -----------------------------------------------------------------------
# # Workforce Identity — external IdP federation + SCIM provisioning
# # -----------------------------------------------------------------------
module "workforce-identity" {
  source                      = "./modules/workforce-identity"
  organization_id             = var.organization_id
  workforce_pool_id           = var.workforce_pool_id
  workforce_pool_display_name = var.workforce_pool_display_name
  workforce_provider_id       = var.workforce_provider_id
  idp_type                    = var.idp_type
  oidc_issuer_uri             = var.oidc_issuer_uri
  oidc_client_id              = var.oidc_client_id
  oidc_client_secret          = var.oidc_client_secret
  saml_idp_metadata_xml       = var.saml_idp_metadata_xml
  session_duration            = var.session_duration
}

# # -----------------------------------------------------------------------
# # Logging Project — dedicated project with org log sinks (GCS + BigQuery)
# # -----------------------------------------------------------------------
# module "logging-project" {
#   source             = "./modules/logging-project"
#   organization_id    = var.organization_id
#   billing_account    = var.billing_account
#   folder_id          = var.demo_folder_name
#   logging_project_id = var.logging_project_id
#   region             = var.region1
#   log_retention_days = var.log_retention_days
#   depends_on         = [module.hostproject]
# }

# # -----------------------------------------------------------------------
# # Security Command Center — SCC notifications → Pub/Sub
# # -----------------------------------------------------------------------
# module "security-command-center" {
#   source                = "./modules/security-command-center"
#   organization_id       = var.organization_id
#   project_id            = var.host-project-name
#   scc_notification_name = var.scc_notification_name
#   pubsub_topic_name     = var.scc_pubsub_topic_name
#   depends_on            = [module.hostproject]
# }
# #-----------------------------------------------------------------------
# # 