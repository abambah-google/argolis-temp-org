<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_service.cloudbilling](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.cloudresourcemanager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.compute](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.container](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.networkservices](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.serviceusage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | the project id of the project | `string` | n/a | yes |
| <a name="input_region1"></a> [region1](#input\_region1) | only run in one region for now for testing | `string` | `"us-east1"` | no |
| <a name="input_region2"></a> [region2](#input\_region2) | only run in one region for now for testing | `string` | `"us-west1"` | no |
| <a name="input_sub-1"></a> [sub-1](#input\_sub-1) | cidr range 1 | `string` | `"10.10.0.0/24"` | no |
| <a name="input_sub-2"></a> [sub-2](#input\_sub-2) | cidr range 2 | `string` | `"10.10.2.0/24"` | no |
| <a name="input_subnetwork1"></a> [subnetwork1](#input\_subnetwork1) | n/a | `string` | n/a | yes |
| <a name="input_subnetwork2"></a> [subnetwork2](#input\_subnetwork2) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name1"></a> [vpc\_name1](#input\_vpc\_name1) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->