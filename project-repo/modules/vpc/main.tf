# Copyright 2024 Google LLC
# Author: abambah@google.com 

resource "google_project_service" "cloudresourcemanager" {
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
  project                    = var.project_id
}

resource "google_project_service" "cloudbilling" {
  service                    = "cloudbilling.googleapis.com"
  disable_dependent_services = true
  project                    = var.project_id
}

resource "google_project_service" "iam" {
  service                    = "iam.googleapis.com"
  disable_dependent_services = true
  project                    = var.project_id
}

resource "google_project_service" "monitoring" {
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = true
  project                    = var.project_id
}


resource "google_project_service" "compute" {
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
  project                    = var.project_id
}

resource "google_project_service" "container" {
  service                    = "container.googleapis.com"
  disable_dependent_services = false
  project                    = var.project_id
}

resource "google_project_service" "serviceusage" {
  service                    = "serviceusage.googleapis.com"
  disable_dependent_services = true
  project                    = var.project_id
}

resource "google_project_service" "networkservices" {
  service                    = "networkservices.googleapis.com"
  project                    = var.project_id
  disable_dependent_services = true
}

resource "google_project_service" "artifactservices" {
  service                    = "artifactregistry.googleapis.com"
  project                    = var.project_id
  disable_dependent_services = true
}

locals {
  network_01_name = format("%s-%s", "custom-network", var.project_id)
  network_01_routes = [
    {
      name              = "${local.network_01_name}-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = ["egress-inet"]
      next_hop_internet = "true"
    }
  ]
  subnetwork1-services = format("%s-%s", var.subnetwork1, "services")
  subnetwork2-services = format("%s-%s", var.subnetwork2, "services")
  subnetwork1-pods     = format("%s-%s", var.subnetwork1, "pods")
  subnetwork2-pods     = format("%s-%s", var.subnetwork2, "pods")
}

module "vpc" {
  source = "terraform-google-modules/network/google"

  project_id   = var.project_id
  network_name = local.network_01_name
  routes       = local.network_01_routes
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = var.subnetwork1
      subnet_ip             = var.sub_1
      subnet_region         = var.region1
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
      description           = var.region1
    },
    {
      subnet_name           = var.subnetwork2
      subnet_ip             = var.sub_2
      subnet_region         = var.region2
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
      description           = var.region2
    },
  ]

  secondary_ranges = {
    (var.subnetwork1) = [
      {
        range_name    = local.subnetwork1-services
        ip_cidr_range = var.ip_range_services1
      },
      {
        range_name    = local.subnetwork1-pods
        ip_cidr_range = var.ip_range_pods1
      },
    ]
    (var.subnetwork2) = [
      {
        range_name    = local.subnetwork2-services
        ip_cidr_range = var.ip_range_services2
      },
      {
        range_name    = local.subnetwork2-pods
        ip_cidr_range = var.ip_range_pods2
      },
    ]
  }
  depends_on = [google_project_service.compute]
}

