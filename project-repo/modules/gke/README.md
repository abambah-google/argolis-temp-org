<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_cluster.secondary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.primary_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.secondary_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_compute_subnetwork.subnetwork1](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |
| [google_compute_subnetwork.subnetwork2](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_gke_maximum_worknode_count"></a> [gke\_maximum\_worknode\_count](#input\_gke\_maximum\_worknode\_count) | n/a | `string` | `"5"` | no |
| <a name="input_gke_minimal_worknode_count"></a> [gke\_minimal\_worknode\_count](#input\_gke\_minimal\_worknode\_count) | n/a | `string` | `"1"` | no |
| <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods) | The secondary ip range to use for pods | `string` | `"subnet-01-secondary-pods"` | no |
| <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services) | The secondary ip range to use for pods | `string` | `"subnet-01-secondary-services"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | the project id of the project | `string` | n/a | yes |
| <a name="input_region1"></a> [region1](#input\_region1) | n/a | `string` | `"us-east1"` | no |
| <a name="input_region2"></a> [region2](#input\_region2) | n/a | `string` | `"us-west1"` | no |
| <a name="input_subnetwork1"></a> [subnetwork1](#input\_subnetwork1) | n/a | `string` | n/a | yes |
| <a name="input_subnetwork2"></a> [subnetwork2](#input\_subnetwork2) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name1"></a> [vpc\_name1](#input\_vpc\_name1) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name2"></a> [vpc\_name2](#input\_vpc\_name2) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->