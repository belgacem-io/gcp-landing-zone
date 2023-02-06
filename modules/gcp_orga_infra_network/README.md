<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 4.0, < 5.0 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns-public-zone"></a> [dns-public-zone](#module_dns-public-zone) | terraform-google-modules/cloud-dns/google | ~> 4.2 |
| <a name="module_nethub"></a> [nethub](#module_nethub) | ../shared/gcp_network | n/a |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing_account](#input_billing_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_data_subnet_ranges"></a> [data_subnet_ranges](#input_data_subnet_ranges) | The list of data subnets ranges being created | `list(string)` | n/a | yes |
| <a name="input_default_region"></a> [default_region](#input_default_region) | First subnet region for DNS Hub network. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input_domain) | The DNS name of forwarding managed zone, for instance 'example.com'. Must end with a period. | `string` | n/a | yes |
| <a name="input_gcp_labels"></a> [gcp_labels](#input_gcp_labels) | Map of tags | `map(string)` | n/a | yes |
| <a name="input_network_name"></a> [network_name](#input_network_name) | The network name. | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization_id](#input_organization_id) | The domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com | `string` | n/a | yes |
| <a name="input_parent_id"></a> [parent_id](#input_parent_id) | Can be either an organisation or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_private_subnet_ranges"></a> [private_subnet_ranges](#input_private_subnet_ranges) | The list of private subnets ranges being created | `list(string)` | n/a | yes |
| <a name="input_private_svc_connect_ip"></a> [private_svc_connect_ip](#input_private_svc_connect_ip) | The internal IP to be used for the private service connect. | `string` | n/a | yes |
| <a name="input_private_svc_connect_ranges"></a> [private_svc_connect_ranges](#input_private_svc_connect_ranges) | The list of subnets to publish a managed service by using Private Service Connect. | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project_name](#input_project_name) | Project witch will contains all dns configs | `string` | n/a | yes |
| <a name="input_public_subnet_ranges"></a> [public_subnet_ranges](#input_public_subnet_ranges) | The list of public subnets ranges being created | `list(string)` | n/a | yes |
| <a name="input_terraform_sa_email"></a> [terraform_sa_email](#input_terraform_sa_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_bgp_asn_dns"></a> [bgp_asn_dns](#input_bgp_asn_dns) | BGP Autonomous System Number (ASN). | `number` | `64667` | no |
| <a name="input_dns_enable_logging"></a> [dns_enable_logging](#input_dns_enable_logging) | Toggle DNS logging for VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_dns_inbound_forwarding"></a> [enable_dns_inbound_forwarding](#input_enable_dns_inbound_forwarding) | Toggle inbound query forwarding for Base Hub VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_dns_logging"></a> [enable_dns_logging](#input_enable_dns_logging) | Toggle DNS logging for Base Hub VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_dns_proxy_advertising"></a> [enable_dns_proxy_advertising](#input_enable_dns_proxy_advertising) | Enables routers to advertise DNS proxy range 35.199.192.0/19. | `bool` | `false` | no |
| <a name="input_enable_firewall_logging"></a> [enable_firewall_logging](#input_enable_firewall_logging) | Toggle firewall logging for VPC Firewalls in Base Hub VPC. | `bool` | `true` | no |
| <a name="input_enable_nat"></a> [enable_nat](#input_enable_nat) | Toggle creation of NAT cloud router in Hub. | `bool` | `true` | no |
| <a name="input_enable_optional_fw_rules"></a> [enable_optional_fw_rules](#input_enable_optional_fw_rules) | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges in Hub VPC. | `bool` | `true` | no |
| <a name="input_enable_partner_interconnect"></a> [enable_partner_interconnect](#input_enable_partner_interconnect) | Enable Partner Interconnect in the environment. | `bool` | `false` | no |
| <a name="input_enable_windows_activation"></a> [enable_windows_activation](#input_enable_windows_activation) | Enable Windows license activation for Windows workloads in Base Hub | `bool` | `false` | no |
| <a name="input_infra_folder_name"></a> [infra_folder_name](#input_infra_folder_name) | Folder witch will contains all infra projects | `string` | `"Infrastructure"` | no |
| <a name="input_nat_bgp_asn"></a> [nat_bgp_asn](#input_nat_bgp_asn) | BGP ASN for first NAT cloud routes in Base Hub. | `number` | `64514` | no |
| <a name="input_nat_num_addresses_region1"></a> [nat_num_addresses_region1](#input_nat_num_addresses_region1) | Number of external IPs to reserve for first Cloud NAT in Base Hub. | `number` | `2` | no |
| <a name="input_subnetworks_enable_logging"></a> [subnetworks_enable_logging](#input_subnetworks_enable_logging) | Toggle subnetworks flow logging for VPC Subnetworks. | `bool` | `true` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_subnets_names"></a> [data_subnets_names](#output_data_subnets_names) | n/a |
| <a name="output_network_internet_egress_tag"></a> [network_internet_egress_tag](#output_network_internet_egress_tag) | Network tags for VMs with internet access. |
| <a name="output_private_subnets_names"></a> [private_subnets_names](#output_private_subnets_names) | n/a |
| <a name="output_public_subnets_names"></a> [public_subnets_names](#output_public_subnets_names) | n/a |
| <a name="output_vpc_name"></a> [vpc_name](#output_vpc_name) | n/a |
| <a name="output_vpc_network_self_links"></a> [vpc_network_self_links](#output_vpc_network_self_links) | n/a |
| <a name="output_vpc_subnetwork_self_links"></a> [vpc_subnetwork_self_links](#output_vpc_subnetwork_self_links) | n/a |
<!-- END_TF_DOCS -->