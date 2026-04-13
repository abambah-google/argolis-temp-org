# Copyright 2024 Google LLC
# Author: abambah@google.com
# Firewall module — creates VPC firewall rules.
# NOTE: The terraform backend and provider blocks have been removed
# from this child module — they belong in the root module only.

locals {
  firewall-egress-allow-https-any-to-any = "${var.vpc_name}-egress-allow-https-any-to-any"
  firewall-egress-deny-all               = "${var.vpc_name}-egress-deny-all"
  firewall-ingress-allow-http-any-to-pub = "${var.vpc_name}-ingress-allow-http-any-to-pub"
  firewall-ingress-allow-http-to-priv    = "${var.vpc_name}-ingress-allow-http-to-priv"
  firewall-ingress-deny-all              = "${var.vpc_name}-ingress-deny-all"
}

resource "google_compute_firewall" "global-firewall-egress-allow-http-any-to-any" {
  name               = local.firewall-egress-allow-https-any-to-any
  description        = "FASM-ID : 2429/2431 - VPC allow HTTPS egress traffic"
  project            = var.project_id
  network            = var.vpc_name
  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"
  # enable_logging     = true
  priority           = 30000

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "global-firewall-egress-deny-all" {
  name               = local.firewall-egress-deny-all
  description        = "VPC deny egress All"
  project            = var.project_id
  network            = var.vpc_name
  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"
  # enable_logging     = true
  priority           = 65000

  deny {
    protocol = "all"
  }
}

resource "google_compute_firewall" "global-firewall-ingress-allow-http-any-to-public" {
  name           = local.firewall-ingress-allow-http-any-to-pub
  description    = "FASM-ID : 2548/2549 - VPC allow HTTP ingress traffic from Any to Public"
  project        = var.project_id
  network        = var.vpc_name
  source_ranges  = ["0.0.0.0/0"]
  target_tags    = ["public"]
  direction      = "INGRESS"
  # enable_logging = true
  priority       = 30000

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "global-firewall-ingress-allow-http-to-private" {
  name           = local.firewall-ingress-allow-http-to-priv
  description    = "FASM-ID : 2548/2549 - VPC allow HTTPS ingress traffic from Public/Private to Private"
  project        = var.project_id
  network        = var.vpc_name
  source_tags    = ["private", "public"]
  target_tags    = ["private"]
  direction      = "INGRESS"
  # enable_logging = true
  priority       = 31000

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "global-firewall-ingress-deny-all" {
  name           = local.firewall-ingress-deny-all
  description    = "VPC deny ingress All"
  project        = var.project_id
  network        = var.vpc_name
  source_ranges  = ["0.0.0.0/0"]
  direction      = "INGRESS"
  # enable_logging = true
  priority       = 65000

  deny {
    protocol = "all"
  }
}

# Allow internal traffic within the VPC (RFC 1918 ranges)
resource "google_compute_firewall" "allow-internal" {
  name           = "${var.vpc_name}-ingress-allow-internal"
  description    = "Allow internal RFC 1918 traffic within the VPC"
  project        = var.project_id
  network        = var.vpc_name
  source_ranges  = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  direction      = "INGRESS"
  #enable_logging = true
  priority       = 1000

  allow {
    protocol = "all"
  }
}

# Allow IAP SSH/RDP tunneling
resource "google_compute_firewall" "allow-iap-ssh" {
  name           = "${var.vpc_name}-ingress-allow-iap-ssh"
  description    = "Allow SSH via Cloud IAP"
  project        = var.project_id
  network        = var.vpc_name
  source_ranges  = ["35.235.240.0/20"]
  direction      = "INGRESS"
  # enable_logging = true
  priority       = 1000

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}
