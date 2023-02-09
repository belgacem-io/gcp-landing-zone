<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_data_subnet_ranges"></a> [data\_subnet\_ranges](#input\_data\_subnet\_ranges) | The list of data subnets ranges being created | `list(string)` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | First subnet region for DNS Hub network. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | The DNS name of forwarding managed zone, for instance 'example.com'. Must end with a period. | `string` | n/a | yes |
| <a name="input_gcp_labels"></a> [gcp\_labels](#input\_gcp\_labels) | Map of tags | `map(string)` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The network name. | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com | `string` | n/a | yes |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | Can be either an organisation or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_private_subnet_ranges"></a> [private\_subnet\_ranges](#input\_private\_subnet\_ranges) | The list of private subnets ranges being created | `list(string)` | n/a | yes |
| <a name="input_private_svc_connect_ip"></a> [private\_svc\_connect\_ip](#input\_private\_svc\_connect\_ip) | The internal IP to be used for the private service connect. | `string` | n/a | yes |
| <a name="input_private_svc_connect_ranges"></a> [private\_svc\_connect\_ranges](#input\_private\_svc\_connect\_ranges) | The list of subnets to publish a managed service by using Private Service Connect. | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project witch will contains all dns configs | `string` | n/a | yes |
| <a name="input_public_subnet_ranges"></a> [public\_subnet\_ranges](#input\_public\_subnet\_ranges) | The list of public subnets ranges being created | `list(string)` | n/a | yes |
| <a name="input_terraform_sa_email"></a> [terraform\_sa\_email](#input\_terraform\_sa\_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_bgp_asn_dns"></a> [bgp\_asn\_dns](#input\_bgp\_asn\_dns) | BGP Autonomous System Number (ASN). | `number` | `64667` | no |
| <a name="input_dns_enable_logging"></a> [dns\_enable\_logging](#input\_dns\_enable\_logging) | Toggle DNS logging for VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_dns_inbound_forwarding"></a> [enable\_dns\_inbound\_forwarding](#input\_enable\_dns\_inbound\_forwarding) | Toggle inbound query forwarding for Base Hub VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_dns_logging"></a> [enable\_dns\_logging](#input\_enable\_dns\_logging) | Toggle DNS logging for Base Hub VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_dns_proxy_advertising"></a> [enable\_dns\_proxy\_advertising](#input\_enable\_dns\_proxy\_advertising) | Enables routers to advertise DNS proxy range 35.199.192.0/19. | `bool` | `false` | no |
| <a name="input_enable_firewall_logging"></a> [enable\_firewall\_logging](#input\_enable\_firewall\_logging) | Toggle firewall logging for VPC Firewalls in Base Hub VPC. | `bool` | `true` | no |
| <a name="input_enable_nat"></a> [enable\_nat](#input\_enable\_nat) | Toggle creation of NAT cloud router in Hub. | `bool` | `true` | no |
| <a name="input_enable_optional_fw_rules"></a> [enable\_optional\_fw\_rules](#input\_enable\_optional\_fw\_rules) | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges in Hub VPC. | `bool` | `true` | no |
| <a name="input_enable_partner_interconnect"></a> [enable\_partner\_interconnect](#input\_enable\_partner\_interconnect) | Enable Partner Interconnect in the environment. | `bool` | `false` | no |
| <a name="input_enable_windows_activation"></a> [enable\_windows\_activation](#input\_enable\_windows\_activation) | Enable Windows license activation for Windows workloads in Base Hub | `bool` | `false` | no |
| <a name="input_infra_folder_name"></a> [infra\_folder\_name](#input\_infra\_folder\_name) | Folder witch will contains all infra projects | `string` | `"Infrastructure"` | no |
| <a name="input_nat_bgp_asn"></a> [nat\_bgp\_asn](#input\_nat\_bgp\_asn) | BGP ASN for first NAT cloud routes in Base Hub. | `number` | `64514` | no |
| <a name="input_nat_num_addresses_region1"></a> [nat\_num\_addresses\_region1](#input\_nat\_num\_addresses\_region1) | Number of external IPs to reserve for first Cloud NAT in Base Hub. | `number` | `2` | no |
| <a name="input_subnetworks_enable_logging"></a> [subnetworks\_enable\_logging](#input\_subnetworks\_enable\_logging) | Toggle subnetworks flow logging for VPC Subnetworks. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_subnets_names"></a> [data\_subnets\_names](#output\_data\_subnets\_names) | n/a |
| <a name="output_private_subnets_names"></a> [private\_subnets\_names](#output\_private\_subnets\_names) | n/a |
| <a name="output_public_subnets_names"></a> [public\_subnets\_names](#output\_public\_subnets\_names) | n/a |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | n/a |
| <a name="output_vpc_network_self_links"></a> [vpc\_network\_self\_links](#output\_vpc\_network\_self\_links) | n/a |
| <a name="output_vpc_subnetwork_self_links"></a> [vpc\_subnetwork\_self\_links](#output\_vpc\_subnetwork\_self\_links) | n/a |
<!-- END_TF_DOCS -->