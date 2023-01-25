<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_all\_egress\_ranges | List of network ranges to which all egress traffic will be allowed | `any` | `null` | no |
| allow\_all\_ingress\_ranges | List of network ranges from which all ingress traffic will be allowed | `any` | `null` | no |
| bgp\_asn\_subnet | BGP ASN for Subnets cloud routers. | `number` | n/a | yes |
| default\_region1 | Default region 1 for subnets and Cloud Routers | `string` | n/a | yes |
| default\_region2 | Default region 2 for subnets and Cloud Routers | `string` | n/a | yes |
| dns\_enable\_inbound\_forwarding | Toggle inbound query forwarding for VPC DNS. | `bool` | `true` | no |
| dns\_enable\_logging | Toggle DNS logging for VPC DNS. | `bool` | `true` | no |
| domain | The DNS name of peering managed zone, for instance 'example.com.' | `string` | n/a | yes |
| environment\_code | A short form of the folder level resources (environment) within the Google Cloud organization. | `string` | n/a | yes |
| firewall\_enable\_logging | Toggle firewall logging for VPC Firewalls. | `bool` | `true` | no |
| folder\_prefix | Name prefix to use for folders created. | `string` | `"fldr"` | no |
| mode | Network deployment mode, should be set to `hub` or `spoke` when `enable_hub_and_spoke` architecture chosen, keep as `null` otherwise. | `string` | `null` | no |
| nat\_bgp\_asn | BGP ASN for first NAT cloud routes. | `number` | `0` | no |
| nat\_enabled | Toggle creation of NAT cloud router. | `bool` | `false` | no |
| nat\_num\_addresses | Number of external IPs to reserve for Cloud NAT. | `number` | `2` | no |
| nat\_num\_addresses\_region1 | Number of external IPs to reserve for first Cloud NAT. | `number` | `2` | no |
| nat\_num\_addresses\_region2 | Number of external IPs to reserve for second Cloud NAT. | `number` | `2` | no |
| optional\_fw\_rules\_enabled | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges. | `bool` | `false` | no |
| org\_id | Organization ID | `string` | n/a | yes |
| parent\_folder | Optional - if using a folder for testing. | `string` | `""` | no |
| private\_service\_cidr | CIDR range for private service networking. Used for Cloud SQL and other managed services. | `string` | `null` | no |
| project\_id | Project ID for Private Shared VPC. | `string` | n/a | yes |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| subnets | The list of subnets being created | `list(map(string))` | `[]` | no |
| windows\_activation\_enabled | Enable Windows license activation for Windows workloads. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| region1\_router1 | Router 1 for Region 1 |
| region1\_router2 | Router 2 for Region 1 |
| region2\_router1 | Router 1 for Region 2 |
| region2\_router2 | Router 2 for Region 2 |
| subnets\_flow\_logs | Whether the subnets have VPC flow logs enabled |
| subnets\_ips | The IPs and CIDRs of the subnets being created |
| subnets\_names | The names of the subnets being created |
| subnets\_private\_access | Whether the subnets have access to Google API's without a public IP |
| subnets\_regions | The region where the subnets will be created |
| subnets\_secondary\_ranges | The secondary ranges associated with these subnets |
| subnets\_self\_links | The self-links of subnets being created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 4.0, < 5.0 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns-forwarding-zone"></a> [dns-forwarding-zone](#module_dns-forwarding-zone) | terraform-google-modules/cloud-dns/google | ~> 4.2 |
| <a name="module_main"></a> [main](#module_main) | terraform-google-modules/network/google | ~> 5.2 |
| <a name="module_peering"></a> [peering](#module_peering) | terraform-google-modules/network/google//modules/network-peering | ~> 5.2 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bgp_asn_subnet"></a> [bgp_asn_subnet](#input_bgp_asn_subnet) | BGP ASN for Subnets cloud routers. | `number` | n/a | yes |
| <a name="input_default_region"></a> [default_region](#input_default_region) | Default region 1 for subnets and Cloud Routers | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input_domain) | The DNS name of peering managed zone, for instance 'example.com.' | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment_code](#input_environment_code) | A short form of the folder level resources (environment) within the Google Cloud organization. | `string` | n/a | yes |
| <a name="input_org_id"></a> [org_id](#input_org_id) | Organization ID | `string` | n/a | yes |
| <a name="input_project_id"></a> [project_id](#input_project_id) | Project ID for Private Shared VPC. | `string` | n/a | yes |
| <a name="input_allow_all_egress_ranges"></a> [allow_all_egress_ranges](#input_allow_all_egress_ranges) | List of network ranges to which all egress traffic will be allowed | `list(string)` | `null` | no |
| <a name="input_allow_all_ingress_ranges"></a> [allow_all_ingress_ranges](#input_allow_all_ingress_ranges) | List of network ranges from which all ingress traffic will be allowed | `list(string)` | `null` | no |
| <a name="input_bgp_asn_dns"></a> [bgp_asn_dns](#input_bgp_asn_dns) | BGP Autonomous System Number (ASN). | `number` | `64667` | no |
| <a name="input_data_subnets"></a> [data_subnets](#input_data_subnets) | The list of data subnets being created | <pre>list(object({<br>    project_name = string<br>    subnet_name  = string<br>    subnet_ip    = string<br>  }))</pre> | `[]` | no |
| <a name="input_dns_enable_inbound_forwarding"></a> [dns_enable_inbound_forwarding](#input_dns_enable_inbound_forwarding) | Toggle inbound query forwarding for VPC DNS. | `bool` | `true` | no |
| <a name="input_dns_enable_logging"></a> [dns_enable_logging](#input_dns_enable_logging) | Toggle DNS logging for VPC DNS. | `bool` | `true` | no |
| <a name="input_dns_enable_outbound_forwarding"></a> [dns_enable_outbound_forwarding](#input_dns_enable_outbound_forwarding) | Toggle outbound query forwarding for VPC DNS. if true dns_outbound_server_addresses must be set | `bool` | `false` | no |
| <a name="input_dns_outbound_server_addresses"></a> [dns_outbound_server_addresses](#input_dns_outbound_server_addresses) | List of IPv4 address of target name servers for the forwarding zone configuration. See https://cloud.google.com/dns/docs/overview#dns-forwarding-zones for details on target name servers in the context of Cloud DNS forwarding zones. | <pre>list(object({<br>    ipv4_address    = string,<br>    forwarding_path = string<br>  }))</pre> | `null` | no |
| <a name="input_firewall_enable_logging"></a> [firewall_enable_logging](#input_firewall_enable_logging) | Toggle firewall logging for VPC Firewalls. | `bool` | `true` | no |
| <a name="input_mode"></a> [mode](#input_mode) | Network deployment mode, should be set to `hub` or `spoke`. | `string` | `null` | no |
| <a name="input_nat_bgp_asn"></a> [nat_bgp_asn](#input_nat_bgp_asn) | BGP ASN for first NAT cloud routes. | `number` | `0` | no |
| <a name="input_nat_enabled"></a> [nat_enabled](#input_nat_enabled) | Toggle creation of NAT cloud router. | `bool` | `false` | no |
| <a name="input_nat_num_addresses"></a> [nat_num_addresses](#input_nat_num_addresses) | Number of external IPs to reserve for Cloud NAT. | `number` | `2` | no |
| <a name="input_nat_num_addresses_region1"></a> [nat_num_addresses_region1](#input_nat_num_addresses_region1) | Number of external IPs to reserve for first Cloud NAT. | `number` | `2` | no |
| <a name="input_network_internet_egress_tag"></a> [network_internet_egress_tag](#input_network_internet_egress_tag) | Network tags for VMs with internet access. | `string` | `"egress-internet"` | no |
| <a name="input_optional_fw_rules_enabled"></a> [optional_fw_rules_enabled](#input_optional_fw_rules_enabled) | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges. | `bool` | `false` | no |
| <a name="input_org_nethub_project_id"></a> [org_nethub_project_id](#input_org_nethub_project_id) | Organization hub network project if | `string` | `null` | no |
| <a name="input_org_nethub_vpc_name"></a> [org_nethub_vpc_name](#input_org_nethub_vpc_name) | Organization hub network VPC name | `string` | `null` | no |
| <a name="input_private_service_cidr"></a> [private_service_cidr](#input_private_service_cidr) | CIDR range for private service networking. Used for Cloud SQL and other managed services. | `string` | `null` | no |
| <a name="input_private_subnets"></a> [private_subnets](#input_private_subnets) | The list of private subnets being created | <pre>list(object({<br>    project_name = string<br>    subnet_name  = string<br>    subnet_ip    = string<br>  }))</pre> | `[]` | no |
| <a name="input_private_svc_connect_subnets"></a> [private_svc_connect_subnets](#input_private_svc_connect_subnets) | The list of subnets to publish a managed service by using Private Service Connect. | <pre>list(object({<br>    project_name = string<br>    subnet_name  = string<br>    subnet_ip    = string<br>  }))</pre> | `[]` | no |
| <a name="input_public_subnets"></a> [public_subnets](#input_public_subnets) | The list of public subnets being created | <pre>list(object({<br>    project_name = string<br>    subnet_name  = string<br>    subnet_ip    = string<br>  }))</pre> | `[]` | no |
| <a name="input_secondary_ranges"></a> [secondary_ranges](#input_secondary_ranges) | Secondary ranges that will be used in some of the subnets | <pre>map(list(object({<br>    range_name = string,<br>    ip_cidr_range = string<br>  })))</pre> | `{}` | no |
| <a name="input_subnetworks_enable_logging"></a> [subnetworks_enable_logging](#input_subnetworks_enable_logging) | Toggle subnetworks flow logging for VPC Subnetworks. | `bool` | `false` | no |
| <a name="input_windows_activation_enabled"></a> [windows_activation_enabled](#input_windows_activation_enabled) | Enable Windows license activation for Windows workloads. | `bool` | `false` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_internet_egress_tag"></a> [network_internet_egress_tag](#output_network_internet_egress_tag) | Network tags for VMs with internet access. |
| <a name="output_network_name"></a> [network_name](#output_network_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network_self_link](#output_network_self_link) | The URI of the VPC being created |
| <a name="output_subnets_ids"></a> [subnets_ids](#output_subnets_ids) | The IDs of the subnets being created |
| <a name="output_subnets_names"></a> [subnets_names](#output_subnets_names) | The names of the subnets being created |
| <a name="output_subnets_secondary_ranges"></a> [subnets_secondary_ranges](#output_subnets_secondary_ranges) | The secondary ranges associated with these subnets |
| <a name="output_subnets_self_links"></a> [subnets_self_links](#output_subnets_self_links) | The self-links of subnets being created |
<!-- END_TF_DOCS -->