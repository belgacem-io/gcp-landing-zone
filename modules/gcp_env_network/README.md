<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_business_project_subnets"></a> [business\_project\_subnets](#input\_business\_project\_subnets) | Default subnets for Organization network hub. | <pre>list(object({<br>    project_name                  = string<br>    environment_code              = string<br>    private_subnet_ranges         = list(string)<br>    data_subnet_ranges            = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_data_subnet_ranges"></a> [data\_subnet\_ranges](#input\_data\_subnet\_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | First subnet region. The shared vpc modules only configures two regions. | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | n/a | `string` | n/a | yes |
| <a name="input_infra_nethub_networks_self_links"></a> [infra\_nethub\_networks\_self\_links](#input\_infra\_nethub\_networks\_self\_links) | Organization hub network VPC self link | `map(string)` | n/a | yes |
| <a name="input_infra_nethub_project_id"></a> [infra\_nethub\_project\_id](#input\_infra\_nethub\_project\_id) | Organization hub network project id | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The network name. | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Organization ID | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | The Private domain of your organization | `string` | n/a | yes |
| <a name="input_private_subnet_ranges"></a> [private\_subnet\_ranges](#input\_private\_subnet\_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_private_svc_connect_ip"></a> [private\_svc\_connect\_ip](#input\_private\_svc\_connect\_ip) | The internal IP to be used for the private service connect. Required for hub mode | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Environment hub network project id | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Subnet prefix for env nethub project | `string` | n/a | yes |
| <a name="input_public_domain"></a> [public\_domain](#input\_public\_domain) | The Public domain of your organization | `string` | n/a | yes |
| <a name="input_trusted_egress_ranges"></a> [trusted\_egress\_ranges](#input\_trusted\_egress\_ranges) | List of network ranges to which all egress traffic will be allowed | `list(string)` | n/a | yes |
| <a name="input_trusted_ingress_ranges"></a> [trusted\_ingress\_ranges](#input\_trusted\_ingress\_ranges) | List of network ranges from which all ingress traffic will be allowed | `list(string)` | n/a | yes |
| <a name="input_trusted_private_ranges"></a> [trusted\_private\_ranges](#input\_trusted\_private\_ranges) | List of network ranges from which internal traffic will be allowed | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | n/a |
| <a name="output_network_self_links"></a> [network\_self\_links](#output\_network\_self\_links) | n/a |
| <a name="output_subnetwork_self_links"></a> [subnetwork\_self\_links](#output\_subnetwork\_self\_links) | n/a |
<!-- END_TF_DOCS -->