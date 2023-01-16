<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 3.77 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_env_network_hub"></a> [env_network_hub](#module_env_network_hub) | ../shared/gcp_network_hub | n/a |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_business_project_subnets"></a> [business_project_subnets](#input_business_project_subnets) | Default subnets for Organization network hub. | <pre>list(object({<br>    project_name = string<br>    environment_code = string<br>    region1_primary_ranges  = list(string)<br>    region2_primary_ranges =  list(string)<br>    region1_secondary_ranges = list(string)<br>    region2_secondary_ranges = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_common_services_subnet_region1_ranges"></a> [common_services_subnet_region1_ranges](#input_common_services_subnet_region1_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_common_services_subnet_region2_ranges"></a> [common_services_subnet_region2_ranges](#input_common_services_subnet_region2_ranges) | n/a | `list(string)` | n/a | yes |
| <a name="input_default_region1"></a> [default_region1](#input_default_region1) | First subnet region. The shared vpc modules only configures two regions. | `string` | n/a | yes |
| <a name="input_default_region2"></a> [default_region2](#input_default_region2) | Second subnet region. The shared vpc modules only configures two regions. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input_domain) | The DNS name of peering managed zone, for instance 'example.com.'. Must end with a period. | `string` | n/a | yes |
| <a name="input_env_network_hub_project_id"></a> [env_network_hub_project_id](#input_env_network_hub_project_id) | Environment hub network project id | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment_code](#input_environment_code) | n/a | `string` | n/a | yes |
| <a name="input_org_id"></a> [org_id](#input_org_id) | Organization ID | `string` | n/a | yes |
| <a name="input_org_network_hub_project_id"></a> [org_network_hub_project_id](#input_org_network_hub_project_id) | Organization hub network project id | `string` | n/a | yes |
| <a name="input_org_network_hub_vpc_name"></a> [org_network_hub_vpc_name](#input_org_network_hub_vpc_name) | Organization hub network VPC name | `string` | n/a | yes |
| <a name="input_private_service_cidr"></a> [private_service_cidr](#input_private_service_cidr) | CIDR range for private service networking. Used for Cloud SQL and other managed services. | `string` | n/a | yes |
| <a name="input_terraform_service_account"></a> [terraform_service_account](#input_terraform_service_account) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_dns_enable_inbound_forwarding"></a> [dns_enable_inbound_forwarding](#input_dns_enable_inbound_forwarding) | Toggle inbound query forwarding for VPC DNS. | `bool` | `true` | no |
| <a name="input_dns_enable_logging"></a> [dns_enable_logging](#input_dns_enable_logging) | Toggle DNS logging for VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_hub_and_spoke_transitivity"></a> [enable_hub_and_spoke_transitivity](#input_enable_hub_and_spoke_transitivity) | Enable transitivity via gateway VMs on Hub-and-Spoke architecture. | `bool` | `false` | no |
| <a name="input_enable_partner_interconnect"></a> [enable_partner_interconnect](#input_enable_partner_interconnect) | Enable Partner Interconnect in the environment. | `bool` | `false` | no |
| <a name="input_firewall_enable_logging"></a> [firewall_enable_logging](#input_firewall_enable_logging) | Toggle firewall logging for VPC Firewalls. | `bool` | `true` | no |
| <a name="input_nat_bgp_asn"></a> [nat_bgp_asn](#input_nat_bgp_asn) | BGP ASN for first NAT cloud routes. | `number` | `64514` | no |
| <a name="input_nat_enabled"></a> [nat_enabled](#input_nat_enabled) | Toggle creation of NAT cloud router. | `bool` | `true` | no |
| <a name="input_nat_num_addresses"></a> [nat_num_addresses](#input_nat_num_addresses) | Number of external IPs to reserve for Cloud NAT. | `number` | `2` | no |
| <a name="input_nat_num_addresses_region1"></a> [nat_num_addresses_region1](#input_nat_num_addresses_region1) | Number of external IPs to reserve for first Cloud NAT. | `number` | `2` | no |
| <a name="input_nat_num_addresses_region2"></a> [nat_num_addresses_region2](#input_nat_num_addresses_region2) | Number of external IPs to reserve for second Cloud NAT. | `number` | `2` | no |
| <a name="input_optional_fw_rules_enabled"></a> [optional_fw_rules_enabled](#input_optional_fw_rules_enabled) | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges. | `bool` | `true` | no |
| <a name="input_preactivate_partner_interconnect"></a> [preactivate_partner_interconnect](#input_preactivate_partner_interconnect) | Preactivate Partner Interconnect VLAN attachment in the environment. | `bool` | `false` | no |
| <a name="input_subnetworks_enable_logging"></a> [subnetworks_enable_logging](#input_subnetworks_enable_logging) | Toggle subnetworks flow logging for VPC Subnetworks. | `bool` | `true` | no |
| <a name="input_windows_activation_enabled"></a> [windows_activation_enabled](#input_windows_activation_enabled) | Enable Windows license activation for Windows workloads. | `bool` | `false` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_common_services_subnetwork_self_links"></a> [vpc_common_services_subnetwork_self_links](#output_vpc_common_services_subnetwork_self_links) | n/a |
| <a name="output_vpc_common_services_subnetwork_self_links_by_region"></a> [vpc_common_services_subnetwork_self_links_by_region](#output_vpc_common_services_subnetwork_self_links_by_region) | n/a |
| <a name="output_vpc_name"></a> [vpc_name](#output_vpc_name) | n/a |
| <a name="output_vpc_network_self_links"></a> [vpc_network_self_links](#output_vpc_network_self_links) | n/a |
| <a name="output_vpc_subnetwork_self_links"></a> [vpc_subnetwork_self_links](#output_vpc_subnetwork_self_links) | n/a |
<!-- END_TF_DOCS -->