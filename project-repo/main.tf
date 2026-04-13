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



/*

resource "google_service_account" "terraform_service_account" {
  project = var.host-project-name
  account_id   = "terraform-service-account"
  display_name = "Terraform Service Account"
}

resource "google_organization_iam_member" "access_context_manager_admin" {
  org_id  = var.organization_id
  role    = "roles/accesscontextmanager.policyAdmin"
  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}

resource "google_organization_iam_member" "organization_viewer" {
  org_id  = var.organization_id
  role    = "roles/resourcemanager.organizationViewer"
  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}

resource "google_organization_iam_member" "organization_role_viewer" {
  org_id  = var.organization_id
  role    = "roles/iam.organizationRoleViewer"
  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}

resource "google_organization_iam_member" "service_usage_admin" {
  org_id  = var.organization_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}

*/
module "consumer-project-a" {
  source                = "./modules/projects"
  consumer_project      = var.consumer_project_a_id
  customer_project_name = "Customer project A"
  billing_account       = var.billing_account
  table-name            = "consumer-project-a"
  dataset-id            = "consumer_dataset_a"
  description           = "Consumer Project A BQ table"
  location              = "US"
  # folder_name           = var.demo_folder_name
}
module "consumer-project-b" {
  source                = "./modules/projects"
  consumer_project      = var.consumer_project_b_id
  customer_project_name = "Customer project B"
  billing_account       = var.billing_account
  table-name            = "consumer-project-b"
  dataset-id            = "consumer_dataset_b"
  description           = "Consumer Project B BQ table"
  location              = "US"
 # folder_name           = var.demo_folder_name
}



# A service project gains access to network resources provided by its
# associated host project.
resource "google_compute_shared_vpc_service_project" "service1" {
  host_project    = var.host-project-name
  service_project = var.consumer_project_a_id
}

resource "google_compute_shared_vpc_service_project" "service2" {
  host_project    = var.host-project-name
  service_project = var.consumer_project_b_id
}

module "service_accounts" {
  source     = "./modules/service-accounts"
  project_id = module.consumer-project-a.project_id
  service_account_names = [
    "default-gce",
    "default-gke",
    "default-apps",
    "bastion",
    "ops-admin",
    "auto-admin",
    "builds",
    "events",
    "dns-admin"
  ]
}

module "artifact-registry" {
  source     = "./modules/artifact-registry"
  project_id = module.consumer-project-a.project_id
}

module "private-ca" {
  source     = "./modules/private-ca"
  project_id = module.consumer-project-a.project_id
}

module "org_policy" {
  source          = "./modules/org_policy"
  organization_id = var.organization_id
}

module "workload-identity-ca" {
  source = "./modules/workload-identity-ca"

  project_id                  = module.consumer-project-a.project_id
  ca_pool_name                = "cirrus-workload-uc"
  ca_pool_location            = "us-central1"
  workload_identity_pool_name = "${module.consumer-project-a.project_id}.svc.id.goog"
  cic_yaml_path               = "./gcp/${module.consumer-project-a.project_id}/cic.yaml"

  depends_on = [module.private-ca]
}

module "vpc" {
  source      = "./modules/vpc"
  project_id  = var.host-project-name
  subnetwork1 = "subnet-1"
  subnetwork2 = "subnet-2"
}

module "firewall" {
  source     = "./modules/firewall"
  project_id = var.host-project-name
  vpc_name   = module.vpc.network_01_name
}
