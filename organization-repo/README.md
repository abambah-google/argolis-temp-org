# hostproject

## Prep the system 
brew install terraform \
brew install terraform-docs \
terraform-docs markdown table --output-file README.md  --output-mode inject . 

## Run the code 
terraform init \
terraform plan -var-file=tf-dev.tfvars -out=tf.out \
terrafrom apply -var-file=tf-dev.tfvars "tf.out" 


## Authors and acknowledgment
@abambah 

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.41.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hostproject"></a> [hostproject](#module\_hostproject) | ./modules/hostproject | n/a |

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
| <a name="input_host-project-name"></a> [host-project-name](#input\_host-project-name) | n/a | `string` | `"host-project"` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | organization id required | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->