# Copyright 2024 Google LLC
# Author: abambah@google.com 

module "project-factory" {
  source                      = "terraform-google-modules/project-factory/google"
  random_project_id           = true
  name                        = var.project_id
  # folder_id                   = var.folder_id
  org_id                      = var.organization_id
  billing_account             = var.billing_account
  disable_services_on_destroy = false
  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "orgpolicy.googleapis.com",
  ]
}

module "serviceaccount" {
  source          = "../serviceAccount"
  project_id      = module.project-factory.project_id
  organization_id = var.organization_id
  depends_on      = [module.project-factory]
}

module "vpc" {
  source     = "../vpc"
  project_id = module.project-factory.project_id
  //vpc_name1   = "test1"
  subnetwork1 = "custom-subnet1"
  subnetwork2 = "custom-subnet2"
  region1     = var.region1
  region2     = var.region2
  depends_on  = [module.project-factory]
}

