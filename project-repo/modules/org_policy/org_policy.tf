# Copyright 2024 Google LLC
# Author: abambah@google.com
# Module: org_policy — project/org level policy constraints.

# ------------------------------------------------------------------
# Restrict VPC peering for the project
# ------------------------------------------------------------------
resource "google_org_policy_policy" "restrict_vpc_peering" {
  name   = "organizations/${var.organization_id}/policies/compute.restrictVpcPeering"
  parent = "organizations/${var.organization_id}"

  spec {
    rules {
      deny_all = "TRUE"
    }
  }
}

# ------------------------------------------------------------------
# Skip default network on project creation
# ------------------------------------------------------------------
resource "google_org_policy_policy" "skip_default_network" {
  name   = "organizations/${var.organization_id}/policies/compute.skipDefaultNetworkCreation"
  parent = "organizations/${var.organization_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

# ------------------------------------------------------------------
# Public access prevention for Cloud Storage
# ------------------------------------------------------------------
resource "google_org_policy_policy" "storage_public_access_prevention" {
  name   = "organizations/${var.organization_id}/policies/storage.publicAccessPrevention"
  parent = "organizations/${var.organization_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}