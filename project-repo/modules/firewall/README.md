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
| [google_compute_firewall.global-firewall-egress-allow-http-any-to-any](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.global-firewall-egress-deny-all](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.global-firewall-ingress-allow-http-any-to-public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.global-firewall-ingress-allow-http-to-private](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.global-firewall-ingress-deny-all](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_credentials"></a> [credentials](#input\_credentials) | GCP credentials file | `map` | <pre>{<br>  "core": "../gvts-core-fa7cb69d1b74.json",<br>  "dev": "../gvts-dev-fa7cb69d1b74.json",<br>  "prod": "../gvts-prod-fa7cb69d1b74.json",<br>  "stage": "../gvts-stage-fa7cb69d1b74.json"<br>}</pre> | no |
| <a name="input_envt"></a> [envt](#input\_envt) | n/a | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | the project id of the project | `map` | <pre>{<br>  "core": "gvts-core",<br>  "prod": "gvts-prod",<br>  "stage": "gvts-stage"<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | `"custom-network-sample"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | `"us-central1-a"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->