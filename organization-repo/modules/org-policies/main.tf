# Copyright 2024 Google LLC
# Author: abambah@google.com
# Module: org-policies
# Enforces recommended security organization policies at the org level.

# ----------------------------------------------------------
# Disable Service Account Key Creation
# ----------------------------------------------------------
resource "google_org_policy_policy" "disable_sa_key_creation" {
  name   = "organizations/${var.organization_id}/policies/iam.disableServiceAccountKeyCreation"
  parent = "organizations/${var.organization_id}"

  spec {
    rules {
      enforce = "FALSE"
    }
  }
}

# # ----------------------------------------------------------
# # Disable Service Account Key Upload
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "disable_sa_key_upload" {
#   name   = "organizations/${var.organization_id}/policies/iam.disableServiceAccountKeyUpload"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       enforce = "TRUE"
#     }
#   }
# }

# # ----------------------------------------------------------
# # Require OS Login for all VMs
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "require_os_login" {
#   name   = "organizations/${var.organization_id}/policies/compute.requireOsLogin"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       enforce = "TRUE"
#     }
#   }
# }

# # ----------------------------------------------------------
# # Deny all external (public) IPs on VMs
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "vm_external_ip_access" {
#   name   = "organizations/${var.organization_id}/policies/compute.vmExternalIpAccess"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       deny_all = "TRUE"
#     }
#   }
# }

# # ----------------------------------------------------------
# # Skip default network creation on new projects
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "skip_default_network" {
#   name   = "organizations/${var.organization_id}/policies/compute.skipDefaultNetworkCreation"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       enforce = "TRUE"
#     }
#   }
# }

# # ----------------------------------------------------------
# # Uniform Bucket-Level Access — enforce for all GCS buckets
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "storage_uniform_bucket_level_access" {
#   name   = "organizations/${var.organization_id}/policies/storage.uniformBucketLevelAccess"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       enforce = "TRUE"
#     }
#   }
# }

# # ----------------------------------------------------------
# # Public Access Prevention for Cloud Storage
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "storage_public_access_prevention" {
#   name   = "organizations/${var.organization_id}/policies/storage.publicAccessPrevention"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       enforce = "TRUE"
#     }
#   }
# }

# # ----------------------------------------------------------
# # Restrict allowed IAM policy member domains
# # Prevents external identities outside your org from being granted IAM.
# # allowed_policy_domains should contain your Cloud Identity customer ID(s),
# # e.g. ["C0abc1def", "C0abc1xyz"]
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "iam_allowed_policy_member_domains" {
#   count  = length(var.allowed_policy_domains) > 0 ? 1 : 0
#   name   = "organizations/${var.organization_id}/policies/iam.allowedPolicyMemberDomains"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       values {
#         allowed_values = var.allowed_policy_domains
#       }
#     }
#   }
# }

# # ----------------------------------------------------------
# # Restrict shared VPC host projects (list the allowed host project numbers)
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "restrict_shared_vpc_host_projects" {
#   count  = length(var.allowed_shared_vpc_host_projects) > 0 ? 1 : 0
#   name   = "organizations/${var.organization_id}/policies/compute.restrictSharedVpcHostProjects"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       values {
#         allowed_values = var.allowed_shared_vpc_host_projects
#       }
#     }
#   }
# }

# # ----------------------------------------------------------
# # Disable Automatic IAM Grants for default Service Accounts
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "disable_automatic_iam_grants" {
#   name   = "organizations/${var.organization_id}/policies/iam.automaticIamGrantsForDefaultServiceAccounts"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       enforce = "TRUE"
#     }
#   }
# }

# # ----------------------------------------------------------
# # Restrict VPC peering
# # ----------------------------------------------------------
# resource "google_org_policy_policy" "restrict_vpc_peering" {
#   name   = "organizations/${var.organization_id}/policies/compute.restrictVpcPeering"
#   parent = "organizations/${var.organization_id}"

#   spec {
#     rules {
#       deny_all = "TRUE"
#     }
#   }
# }
