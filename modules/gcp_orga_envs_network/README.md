<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 4.5 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_env_nethub"></a> [env_nethub](#module_env_nethub) | ../shared/gcp_network_hub | n/a |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_business_project_subnets"></a> [business_project_subnets](#input_business_project_subnets) | Default subnets for Organization network hub. | <pre>list(object({<br>    project_name = string<br>    environment_code = string<br>    private_subnet_ranges  = list(string)<br>    data_subnet_ranges =  list(string)<br>    private_subnet_k8s_2nd_ranges = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_default_region1"></a> [default_region1](#input_default_region1) | First subnet region. The shared vpc modules only configures two regions. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input_domain) | The DNS name of peering managed zone, for instance 'example.com.'. Must end with a period. | `string` | n/a | yes |
| <a name="input_env_nethub_data_subnet_ranges"></a> [env_nethub_data_subnet_ranges](#input_env_nethub_data_subnet_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_env_nethub_private_subnet_ranges"></a> [env_nethub_private_subnet_ranges](#input_env_nethub_private_subnet_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_env_nethub_private_svc_connect_ip"></a> [env_nethub_private_svc_connect_ip](#input_env_nethub_private_svc_connect_ip) | The internal IP to be used for the private service connect. Required for hub mode | `string` | n/a | yes |
| <a name="input_env_nethub_private_svc_subnet_ranges"></a> [env_nethub_private_svc_subnet_ranges](#input_env_nethub_private_svc_subnet_ranges) | CIDR range for private service networking. Used for Cloud SQL and other managed services. | `list(string)` | n/a | yes |
| <a name="input_env_nethub_project_id"></a> [env_nethub_project_id](#input_env_nethub_project_id) | Environment hub network project id | `string` | n/a | yes |
| <a name="input_env_nethub_project_name"></a> [env_nethub_project_name](#input_env_nethub_project_name) | Subnet prefix for env nethub project | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment_code](#input_environment_code) | n/a | `string` | n/a | yes |
| <a name="input_org_id"></a> [org_id](#input_org_id) | Organization ID | `string` | n/a | yes |
| <a name="input_org_nethub_project_id"></a> [org_nethub_project_id](#input_org_nethub_project_id) | Organization hub network project id | `string` | n/a | yes |
| <a name="input_org_nethub_vpc_name"></a> [org_nethub_vpc_name](#input_org_nethub_vpc_name) | Organization hub network VPC name | `string` | n/a | yes |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_name"></a> [vpc_name](#output_vpc_name) | n/a |
| <a name="output_vpc_network_self_links"></a> [vpc_network_self_links](#output_vpc_network_self_links) | n/a |
| <a name="output_vpc_subnetwork_self_links"></a> [vpc_subnetwork_self_links](#output_vpc_subnetwork_self_links) | n/a |
| <a name="output_vpc_svc_data_subnetwork_self_links"></a> [vpc_svc_data_subnetwork_self_links](#output_vpc_svc_data_subnetwork_self_links) | n/a |
| <a name="output_vpc_svc_private_subnetwork_self_links"></a> [vpc_svc_private_subnetwork_self_links](#output_vpc_svc_private_subnetwork_self_links) | n/a |
<!-- END_TF_DOCS -->