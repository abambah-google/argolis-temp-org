#!/bin/bash
export ORG_ID="579419163830"
echo "Importing existing Org Policies into Terraform state..."

VARS=""
if [ -f "tf-dev.tfvars" ]; then
  VARS="-var-file=tf-dev.tfvars"
fi

# terraform import $VARS module.org-policies.google_org_policy_policy.disable_sa_key_creation organizations/${ORG_ID}/policies/iam.disableServiceAccountKeyCreation || true
# terraform import $VARS module.org-policies.google_org_policy_policy.disable_sa_key_upload organizations/${ORG_ID}/policies/iam.disableServiceAccountKeyUpload || true
# terraform import $VARS module.org-policies.google_org_policy_policy.require_os_login organizations/${ORG_ID}/policies/compute.requireOsLogin || true
# terraform import $VARS module.org-policies.google_org_policy_policy.vm_external_ip_access organizations/${ORG_ID}/policies/compute.vmExternalIpAccess || true
# terraform import $VARS module.org-policies.google_org_policy_policy.skip_default_network organizations/${ORG_ID}/policies/compute.skipDefaultNetworkCreation || true
# terraform import $VARS module.org-policies.google_org_policy_policy.storage_uniform_bucket_level_access organizations/${ORG_ID}/policies/storage.uniformBucketLevelAccess || true
# terraform import $VARS module.org-policies.google_org_policy_policy.storage_public_access_prevention organizations/${ORG_ID}/policies/storage.publicAccessPrevention || true
# terraform import $VARS module.org-policies.google_org_policy_policy.disable_automatic_iam_grants organizations/${ORG_ID}/policies/iam.automaticIamGrantsForDefaultServiceAccounts || true
# terraform import $VARS module.org-policies.google_org_policy_policy.restrict_vpc_peering organizations/${ORG_ID}/policies/compute.restrictVpcPeering || true

echo "Import complete!"
