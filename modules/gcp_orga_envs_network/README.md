<!-- BEGIN_TF_DOCS -->
#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_business_project_subnets"></a> [business_project_subnets](#input_business_project_subnets) | Default subnets for Organization network hub. | <pre>list(object({<br>    project_name = string<br>    environment_code = string<br>    private_subnet_ranges  = list(string)<br>    data_subnet_ranges =  list(string)<br>    private_subnet_k8s_2nd_ranges = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_data_subnet_ranges"></a> [data_subnet_ranges](#input_data_subnet_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_default_region"></a> [default_region](#input_default_region) | First subnet region. The shared vpc modules only configures two regions. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input_domain) | The DNS name of peering managed zone, for instance 'example.com.'. Must end with a period. | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment_code](#input_environment_code) | n/a | `string` | n/a | yes |
| <a name="input_network_name"></a> [network_name](#input_network_name) | The network name. | `string` | n/a | yes |
| <a name="input_org_id"></a> [org_id](#input_org_id) | Organization ID | `string` | n/a | yes |
| <a name="input_org_nethub_project_id"></a> [org_nethub_project_id](#input_org_nethub_project_id) | Organization hub network project id | `string` | n/a | yes |
| <a name="input_org_nethub_vpc_self_link"></a> [org_nethub_vpc_self_link](#input_org_nethub_vpc_self_link) | Organization hub network VPC self link | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_private_subnet_ranges"></a> [private_subnet_ranges](#input_private_subnet_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_private_svc_connect_ip"></a> [private_svc_connect_ip](#input_private_svc_connect_ip) | The internal IP to be used for the private service connect. Required for hub mode | `string` | n/a | yes |
| <a name="input_private_svc_connect_ranges"></a> [private_svc_connect_ranges](#input_private_svc_connect_ranges) | CIDR range for private service networking. Used for Cloud SQL and other managed services. | `list(string)` | n/a | yes |
| <a name="input_project_id"></a> [project_id](#input_project_id) | Environment hub network project id | `string` | n/a | yes |
| <a name="input_project_name"></a> [project_name](#input_project_name) | Subnet prefix for env nethub project | `string` | n/a | yes |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_name"></a> [network_name](#output_network_name) | n/a |
| <a name="output_network_self_links"></a> [network_self_links](#output_network_self_links) | n/a |
| <a name="output_subnetwork_self_links"></a> [subnetwork_self_links](#output_subnetwork_self_links) | n/a |
<!-- END_TF_DOCS -->