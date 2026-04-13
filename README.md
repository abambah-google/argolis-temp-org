# Google Cloud Infrastructure Management with Terraform

This project contains two Terraform repositories for managing Google Cloud resources at scale:
`organization-repo` (org-level foundations) and `project-repo` (customer service projects).

---

## Repository Structure

```
.
├── startup2.bash          # Bootstrap script — run once to initialize everything
├── organization-repo/     # Org-level foundations (run first)
└── project-repo/          # Customer/service projects (run after org-repo)
```

---

## `organization-repo`

Sets up **org-level foundational infrastructure**. Must be applied before `project-repo`.

### Modules

| Module | Description |
|---|---|
| `modules/hostproject` | Creates the Shared VPC host project (via `project-factory`), VPC with subnets, GKE cluster, and Artifact Registry |
| `modules/vpc` | VPC networks, subnets, secondary ranges (pods/services), and routes |
| `modules/gke` | GKE cluster provisioning attached to the host project VPC |
| `modules/serviceAccount` | Terraform runtime service accounts |
| `modules/iam-bindings` | Project-level IAM role bindings for all service accounts |
| `modules/ArtifactRepository` | Artifact Registry repositories |
| `modules/org-policies` | **[NEW]** 11 org-level security constraints (see below) |
| `modules/workforce-identity` | **[NEW]** Workforce Identity Pool + OIDC/SAML provider + SCIM provisioning |
| `modules/logging-project` | **[NEW]** Dedicated logging project with org-aggregated log sinks (GCS + BigQuery) |
| `modules/security-command-center` | **[NEW]** SCC notification config streaming findings to Pub/Sub |

### Organization Policies Enforced

The `modules/org-policies` module enforces the following at the **organization level**:

| Constraint | Effect |
|---|---|
| `iam.disableServiceAccountKeyCreation` | Prevents creation of SA keys |
| `iam.disableServiceAccountKeyUpload` | Prevents upload of external SA keys |
| `iam.automaticIamGrantsForDefaultServiceAccounts` | Disabled (no auto Editor binding) |
| `iam.allowedPolicyMemberDomains` | Restricts IAM to your Cloud Identity domain(s) |
| `compute.requireOsLogin` | Enforces OS Login on all VMs |
| `compute.vmExternalIpAccess` | Deny all — no public IPs on VMs |
| `compute.skipDefaultNetworkCreation` | No default network on new projects |
| `compute.restrictVpcPeering` | Deny all VPC peering |
| `compute.restrictSharedVpcHostProjects` | Restricts who can be a Shared VPC host |
| `storage.uniformBucketLevelAccess` | Enforced on all GCS buckets |
| `storage.publicAccessPrevention` | Prevents public GCS bucket access |

### Workforce Identity + SCIM

The `modules/workforce-identity` module creates:
- A **Workforce Identity Pool** at the org level
- An **OIDC or SAML provider** (set `idp_type = "oidc"` or `"saml"` in tfvars)
- The **SCIM 2.0 endpoint URI** is emitted as an output — wire it into your IdP's provisioning settings

### Logging Project

The `modules/logging-project` module creates:
- A dedicated **logging project** (separate from host/service projects)
- A **GCS bucket** for log archival (`NEARLINE` → `COLDLINE` lifecycle)
- An **org-aggregated log sink** → GCS (captures logs from all child projects)
- A **BigQuery dataset** + org sink for security log analytics (audit + WARNING+)

### Security Command Center

The `modules/security-command-center` module:
- Enables `securitycenter.googleapis.com` and `securitycentermanagement.googleapis.com`
- Creates a **Pub/Sub topic + subscription** for SCC findings
- Creates a `google_scc_notification_config` streaming all `ACTIVE` findings to Pub/Sub

### Key Variables (`tf-dev.tfvars`)

```hcl
organization_id   = "YOUR_ORG_ID"
billing_account   = "YOUR_BILLING_ACCOUNT"
host-project-name = "YOUR_HOST_PROJECT_ID"
demo_folder_name  = "YOUR_FOLDER_ID_OR_NAME"

# Logging project
logging_project_id = "YOUR_ORG_ID-logging-project"

# Workforce Identity
workforce_pool_id     = "corp-workforce-pool"
workforce_provider_id = "corp-idp-provider"
idp_type              = "oidc"       # or "saml"
oidc_issuer_uri       = "https://YOUR_IDP.example.com"
oidc_client_id        = "YOUR_CLIENT_ID"

# SCC
scc_notification_name = "org-scc-notifications"
scc_pubsub_topic_name = "scc-findings-topic"

# Domain restriction (optional — leave empty [] to skip)
allowed_policy_domains = ["C0YOUR_CUSTOMER_ID"]
```

---

## `project-repo`

Creates and manages **customer/service projects** that consume shared infrastructure from `organization-repo`.

### Modules

| Module | Description |
|---|---|
| `modules/projects` | Creates consumer projects via `project-factory` |
| `modules/service-accounts` | Service accounts in consumer projects |
| `modules/firewall` | VPC firewall rules (egress/ingress allow/deny + IAP SSH + internal) |
| `modules/org_policy` | Additional org-policy constraints at org level |
| `modules/artifact-registry` | Artifact Registry repositories in service projects |
| `modules/bigquery` | BigQuery datasets |
| `modules/pubsub` | Pub/Sub topics and subscriptions |
| `modules/private-ca` | Certificate Authority Service (Private CA) |

---

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- An existing Google Cloud Organization
- gcloud authenticated with an account that has **Organization Admin** + **Billing Admin**

### Automated Bootstrap (Recommended)

The `startup2.bash` script handles everything end-to-end:

```bash
# 1. Edit the USER-CONFIGURABLE VARIABLES section at the top of the script
vi startup2.bash

# 2. Make executable and run
chmod +x startup2.bash
./startup2.bash
```

The script will:
1. Create a Terraform state project and GCS state bucket
2. Create and configure a `terraform-org-admin` service account with all required org-level IAM roles
3. Enable required APIs
4. Generate `backend.tf` and `terraform.tfvars` for both repos
5. Run `terraform init` + `terraform apply` on `organization-repo`, then `project-repo`

### Manual Deployment

```bash
# Step 1 — Organization foundations
cd organization-repo
terraform init
terraform plan  -var-file=tf-dev.tfvars -out=tf.out
terraform apply "tf.out"

# Step 2 — Service/customer projects (after Step 1 is complete)
cd ../project-repo
terraform init
terraform plan  -var-file=tf-dev.tfvars -out=tf.out
terraform apply "tf.out"
```

---

## Authors

- @abambah
