data "google_client_config" "current" {}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_service_account" "terraform_service_account" {
  project      = var.project_id
  account_id   = "terraform-service-account"
  display_name = "Terraform Service Account"
}

locals {
  custom_sas = {
    "default-apps" = "Default Apps Service Account"
    "bastion"      = "Bastion/GKE Jumpbox Service Account"
    "ops-admin"    = "Operations Admin Service Account"
    "builds"       = "CI/CD Build Service Account"
    "events"       = "Eventarc/PubSub Service Account"
    "dns-admin"    = "DNS Admin Service Account"
    "default-gce"  = "Default GCE Service Account"
    "default-gke"  = "Default GKE Service Account"
  }
}

resource "google_service_account" "custom_sas" {
  for_each     = local.custom_sas
  project      = var.project_id
  account_id   = each.key
  display_name = each.value
}

locals {
  sa_member = "serviceAccount:${google_service_account.terraform_service_account.email}"
}

resource "google_project_iam_member" "service_owner_admin" {
  project = var.project_id
  role    = "roles/owner"
  member  = local.sa_member
}

resource "google_service_account_iam_member" "token_creator" {
  service_account_id = google_service_account.terraform_service_account.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = local.sa_member
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = local.sa_member
}

resource "google_organization_iam_member" "access_context_manager_admin" {
  org_id = var.organization_id
  role   = "roles/accesscontextmanager.policyAdmin"
  member = local.sa_member
}

resource "google_organization_iam_member" "organization_viewer" {
  org_id = var.organization_id
  role   = "roles/resourcemanager.organizationViewer"
  member = local.sa_member
}

resource "google_organization_iam_member" "organization_role_viewer" {
  org_id = var.organization_id
  role   = "roles/iam.organizationRoleViewer"
  member = local.sa_member
}

resource "google_organization_iam_member" "service_usage_admin" {
  org_id = var.organization_id
  role   = "roles/serviceusage.serviceUsageAdmin"
  member = local.sa_member
}