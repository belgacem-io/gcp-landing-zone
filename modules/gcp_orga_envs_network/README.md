<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_business_project_subnets"></a> [business\_project\_subnets](#input\_business\_project\_subnets) | Default subnets for Organization network hub. | <pre>list(object({<br>    project_name = string<br>    environment_code = string<br>    private_subnet_ranges  = list(string)<br>    data_subnet_ranges =  list(string)<br>    private_subnet_k8s_2nd_ranges = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_data_subnet_ranges"></a> [data\_subnet\_ranges](#input\_data\_subnet\_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | First subnet region. The shared vpc modules only configures two regions. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | The DNS name of peering managed zone, for instance 'example.com.'. Must end with a period. | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | n/a | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The network name. | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Organization ID | `string` | n/a | yes |
| <a name="input_org_nethub_project_id"></a> [org\_nethub\_project\_id](#input\_org\_nethub\_project\_id) | Organization hub network project id | `string` | n/a | yes |
| <a name="input_org_nethub_vpc_self_link"></a> [org\_nethub\_vpc\_self\_link](#input\_org\_nethub\_vpc\_self\_link) | Organization hub network VPC self link | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_private_subnet_ranges"></a> [private\_subnet\_ranges](#input\_private\_subnet\_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_private_svc_connect_ip"></a> [private\_svc\_connect\_ip](#input\_private\_svc\_connect\_ip) | The internal IP to be used for the private service connect. Required for hub mode | `string` | n/a | yes |
| <a name="input_private_svc_connect_ranges"></a> [private\_svc\_connect\_ranges](#input\_private\_svc\_connect\_ranges) | CIDR range for private service networking. Used for Cloud SQL and other managed services. | `list(string)` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Environment hub network project id | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Subnet prefix for env nethub project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | n/a |
| <a name="output_network_self_links"></a> [network\_self\_links](#output\_network\_self\_links) | n/a |
| <a name="output_subnetwork_self_links"></a> [subnetwork\_self\_links](#output\_subnetwork\_self\_links) | n/a |
<!-- END_TF_DOCS -->