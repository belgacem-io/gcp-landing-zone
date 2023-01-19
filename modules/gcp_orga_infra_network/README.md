<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 4.5 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns-public-zone"></a> [dns-public-zone](#module_dns-public-zone) | terraform-google-modules/cloud-dns/google | ~> 4.2 |
| <a name="module_nethub"></a> [nethub](#module_nethub) | ../shared/gcp_network_hub | n/a |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing_account](#input_billing_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_default_region1"></a> [default_region1](#input_default_region1) | First subnet region for DNS Hub network. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input_domain) | The DNS name of forwarding managed zone, for instance 'example.com'. Must end with a period. | `string` | n/a | yes |
| <a name="input_gcp_labels"></a> [gcp_labels](#input_gcp_labels) | Map of tags | `map(string)` | n/a | yes |
| <a name="input_nethub_project_name"></a> [nethub_project_name](#input_nethub_project_name) | Project witch will contains all dns configs | `string` | n/a | yes |
| <a name="input_orga_nethub_subnets"></a> [orga_nethub_subnets](#input_orga_nethub_subnets) | Default subnets for Organization network hub. | <pre>object({<br>    public_subnet_ranges = list(string)<br>    private_subnet_ranges  = list(string)<br>    data_subnet_ranges =  list(string)<br>  })</pre> | n/a | yes |
| <a name="input_organization_id"></a> [organization_id](#input_organization_id) | The domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com | `string` | n/a | yes |
| <a name="input_parent_id"></a> [parent_id](#input_parent_id) | Can be either an organisation or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_terraform_sa_email"></a> [terraform_sa_email](#input_terraform_sa_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_bgp_asn_dns"></a> [bgp_asn_dns](#input_bgp_asn_dns) | BGP Autonomous System Number (ASN). | `number` | `64667` | no |
| <a name="input_dns_enable_logging"></a> [dns_enable_logging](#input_dns_enable_logging) | Toggle DNS logging for VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_dns_proxy_advertising"></a> [enable_dns_proxy_advertising](#input_enable_dns_proxy_advertising) | Enables routers to advertise DNS proxy range 35.199.192.0/19. | `bool` | `false` | no |
| <a name="input_enable_orga_nethub_dns_inbound_forwarding"></a> [enable_orga_nethub_dns_inbound_forwarding](#input_enable_orga_nethub_dns_inbound_forwarding) | Toggle inbound query forwarding for Base Hub VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_orga_nethub_dns_logging"></a> [enable_orga_nethub_dns_logging](#input_enable_orga_nethub_dns_logging) | Toggle DNS logging for Base Hub VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_orga_nethub_firewall_logging"></a> [enable_orga_nethub_firewall_logging](#input_enable_orga_nethub_firewall_logging) | Toggle firewall logging for VPC Firewalls in Base Hub VPC. | `bool` | `true` | no |
| <a name="input_enable_orga_nethub_nat"></a> [enable_orga_nethub_nat](#input_enable_orga_nethub_nat) | Toggle creation of NAT cloud router in Hub. | `bool` | `true` | no |
| <a name="input_enable_orga_nethub_optional_fw_rules"></a> [enable_orga_nethub_optional_fw_rules](#input_enable_orga_nethub_optional_fw_rules) | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges in Hub VPC. | `bool` | `true` | no |
| <a name="input_enable_orga_nethub_windows_activation"></a> [enable_orga_nethub_windows_activation](#input_enable_orga_nethub_windows_activation) | Enable Windows license activation for Windows workloads in Base Hub | `bool` | `false` | no |
| <a name="input_enable_partner_interconnect"></a> [enable_partner_interconnect](#input_enable_partner_interconnect) | Enable Partner Interconnect in the environment. | `bool` | `false` | no |
| <a name="input_infra_folder_name"></a> [infra_folder_name](#input_infra_folder_name) | Folder witch will contains all infra projects | `string` | `"Infrastructure"` | no |
| <a name="input_orga_nethub_nat_bgp_asn"></a> [orga_nethub_nat_bgp_asn](#input_orga_nethub_nat_bgp_asn) | BGP ASN for first NAT cloud routes in Base Hub. | `number` | `64514` | no |
| <a name="input_orga_nethub_nat_num_addresses_region1"></a> [orga_nethub_nat_num_addresses_region1](#input_orga_nethub_nat_num_addresses_region1) | Number of external IPs to reserve for first Cloud NAT in Base Hub. | `number` | `2` | no |
| <a name="input_subnetworks_enable_logging"></a> [subnetworks_enable_logging](#input_subnetworks_enable_logging) | Toggle subnetworks flow logging for VPC Subnetworks. | `bool` | `true` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_org_nethub_private_subnets_names"></a> [org_nethub_private_subnets_names](#output_org_nethub_private_subnets_names) | n/a |
| <a name="output_org_nethub_vpc_name"></a> [org_nethub_vpc_name](#output_org_nethub_vpc_name) | n/a |
<!-- END_TF_DOCS -->