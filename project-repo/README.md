
# Prep the system
brew install terraform \
brew install terraform-docs \ 
terraform-docs markdown table --output-file README.md  --output-mode inject .

# Run the code
terraform init \
terraform plan -var-file=tf-dev.tfvars -out=tf.out \
terrafrom apply -var-file=tf-dev.tfvars "tf.out"

# Authors and acknowledgment
@abambah

<!-- BEGIN_TF_DOCS -->
## Requirements
    Create multiple customer projects within BigQuery.
    Associate these customer projects with a single host project.

### Requirement 1: Create Multiple Customer Projects

### Goal: Establish individual BigQuery projects for each customer.

### Acceptance Criteria:
A new BigQuery project is created for each customer.
Project names adhere to defined naming conventions.
Necessary permissions and roles are assigned to project members.

### Requirement 2: Associate Customer Projects with Host Project

### Goal: Link customer projects to a central host project for management and governance.

### Acceptance Criteria:

Customer projects are successfully associated with the host project.
Data sharing and access controls are configured between projects.
Billing and cost management are implemented at the host project level.


## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_GKE"></a> [GKE](#module\_GKE) | modules/GKE | n/a |
| <a name="module_consumer-project-a"></a> [consumer-project-a](#module\_consumer-project-a) | modules/projects | n/a |
| <a name="module_consumer-project-b"></a> [consumer-project-b](#module\_consumer-project-b) | modules/projects | n/a |
| <a name="module_sharedVPC"></a> [sharedVPC](#module\_sharedVPC) | modules/sharedvpc | n/a |

## Resources

| Name | Type |
|------|------|
| [google_folder.terraform_demo](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_organization_iam_member.access_context_manager_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_organization_iam_member.organization_role_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_organization_iam_member.organization_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_organization_iam_member.service_usage_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_service_account.terraform_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | billing account required | `string` | n/a | yes |
| <a name="input_cloud_storage_bucket_name"></a> [cloud\_storage\_bucket\_name](#input\_cloud\_storage\_bucket\_name) | globally unique name of cloud storage bucket to be created | `string` | n/a | yes |
| <a name="input_consumer_project_a_id"></a> [consumer\_project\_a\_id](#input\_consumer\_project\_a\_id) | globally unique id of consumer project a to be created | `string` | n/a | yes |
| <a name="input_consumer_project_b_id"></a> [consumer\_project\_b\_id](#input\_consumer\_project\_b\_id) | globally unique id of consumer project b to be created | `string` | n/a | yes |
| <a name="input_create_default_access_policy"></a> [create\_default\_access\_policy](#input\_create\_default\_access\_policy) | Whether a default access policy needs to be created for the organization. If one already exists, this should be set to false. | `bool` | `false` | no |
| <a name="input_demo_folder_name"></a> [demo\_folder\_name](#input\_demo\_folder\_name) | unique name of demo folder to be created | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | organization id required | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->.
- ├── LICENSE
- ├── README.md
- ├── kubernetes-application
    - │   ├── main.tf
    - │   ├── variables.tf
    - │   └── versions.tf
- ├── main.tf
- ├── modules
    - │   ├── firewall
        - │   │   ├── README.md
        - │   │   ├── main.tf
        - │   │   └── variables.tf
    - │   ├── gke
        - │   │   ├── README.md
        - │   │   ├── main.tf
        - │   │   ├── terraform.tfstate
        - │   │   ├── terraform.tfstate.backup
        - │   │   ├── tf.out
        - │   │   └── variable.tf
    - │   ├── org_policy
        - │   │   ├── backend_config_script.sh
        - │   │   ├── org_policy.tf
        - │   │   ├── variables.tf
        - │   │   └── versions.tf
    - │   ├── projects
        - │   │   ├── bigquery
            - │   │   │   ├── main.tf
            - │   │   │   └── variable.tf
        - │   │   ├── main.tf
        - │   │   └── variable.tf
    - │   ├── pubsub
        - │   │   ├── main.tf
        - │   │   └── variable.tf
    - │   └── sharedvpc
        - │       ├── README.md
        - │       ├── main.tf
        - │       ├── terraform.tfstate
        - │       ├── terraform.tfstate.backup
        - │       └── variables.tf
- ├── sample.gitlab-ci.yml
- └── variables.tf

10 directories, 32 files
