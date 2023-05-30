<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name                             | Description                                                                                                                                  | Type                                                                 | Default  | Required |
|----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|----------|:--------:|
| allow\_all\_egress\_ranges       | List of network ranges to which all egress traffic will be allowed                                                                           | `any`                                                                | `null`   |    no    |
| allow\_all\_ingress\_ranges      | List of network ranges from which all ingress traffic will be allowed                                                                        | `any`                                                                | `null`   |    no    |
| default\_region1                 | Default region 1 for subnets and Cloud Routers                                                                                               | `string`                                                             | n/a      |   yes    |
| default\_region2                 | Default region 2 for subnets and Cloud Routers                                                                                               | `string`                                                             | n/a      |   yes    |
| dns\_enable\_inbound\_forwarding | Toggle inbound query forwarding for VPC DNS.                                                                                                 | `bool`                                                               | `true`   |    no    |
| dns\_enable\_logging             | Toggle DNS logging for VPC DNS.                                                                                                              | `bool`                                                               | `true`   |    no    |
| domain                           | The DNS name of peering managed zone, for instance 'example.com.'                                                                            | `string`                                                             | n/a      |   yes    |
| environment\_code                | A short form of the folder level resources (environment) within the Google Cloud organization.                                               | `string`                                                             | n/a      |   yes    |
| firewall\_enable\_logging        | Toggle firewall logging for VPC Firewalls.                                                                                                   | `bool`                                                               | `true`   |    no    |
| folder\_prefix                   | Name prefix to use for folders created.                                                                                                      | `string`                                                             | `"fldr"` |    no    |
| mode                             | Network deployment mode, should be set to `hub` or `spoke` when `enable_hub_and_spoke` architecture chosen, keep as `null` otherwise.        | `string`                                                             | `null`   |    no    |
| nat\_bgp\_asn                    | BGP ASN for first NAT cloud routes.                                                                                                          | `number`                                                             | `0`      |    no    |
| nat\_enabled                     | Toggle creation of NAT cloud router.                                                                                                         | `bool`                                                               | `false`  |    no    |
| nat\_num\_addresses              | Number of external IPs to reserve for Cloud NAT.                                                                                             | `number`                                                             | `2`      |    no    |
| nat\_num\_addresses\_region1     | Number of external IPs to reserve for first Cloud NAT.                                                                                       | `number`                                                             | `2`      |    no    |
| nat\_num\_addresses\_region2     | Number of external IPs to reserve for second Cloud NAT.                                                                                      | `number`                                                             | `2`      |    no    |
| optional\_fw\_rules\_enabled     | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges. | `bool`                                                               | `false`  |    no    |
| org\_id                          | Organization ID                                                                                                                              | `string`                                                             | n/a      |   yes    |
| parent\_folder                   | Optional - if using a folder for testing.                                                                                                    | `string`                                                             | `""`     |    no    |
| private\_service\_cidr           | CIDR range for private service networking. Used for Cloud SQL and other managed services.                                                    | `string`                                                             | `null`   |    no    |
| project\_id                      | Project ID for Private Shared VPC.                                                                                                           | `string`                                                             | n/a      |   yes    |
| secondary\_ranges                | Secondary ranges that will be used in some of the subnets                                                                                    | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}`     |    no    |
| subnets                          | The list of subnets being created                                                                                                            | `list(map(string))`                                                  | `[]`     |    no    |
| windows\_activation\_enabled     | Enable Windows license activation for Windows workloads.                                                                                     | `bool`                                                               | `false`  |    no    |

## Outputs

| Name                       | Description                                                         |
|----------------------------|---------------------------------------------------------------------|
| network\_name              | The name of the VPC being created                                   |
| network\_self\_link        | The URI of the VPC being created                                    |
| region1\_router1           | Router 1 for Region 1                                               |
| region1\_router2           | Router 2 for Region 1                                               |
| region2\_router1           | Router 1 for Region 2                                               |
| region2\_router2           | Router 2 for Region 2                                               |
| subnets\_flow\_logs        | Whether the subnets have VPC flow logs enabled                      |
| subnets\_ips               | The IPs and CIDRs of the subnets being created                      |
| subnets\_names             | The names of the subnets being created                              |
| subnets\_private\_access   | Whether the subnets have access to Google API's without a public IP |
| subnets\_regions           | The region where the subnets will be created                        |
| subnets\_secondary\_ranges | The secondary ranges associated with these subnets                  |
| subnets\_self\_links       | The self-links of subnets being created                             |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region 1 for subnets and Cloud Routers | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | A short form of the folder level resources (environment) within the Google Cloud organization. | `string` | n/a | yes |
| <a name="input_internal_trusted_cidr_ranges"></a> [internal\_trusted\_cidr\_ranges](#input\_internal\_trusted\_cidr\_ranges) | Internal trusted ip ranges. Must be set to private ip ranges | `list(string)` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The network name. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | The organization's private domain (DNS), for instance 'example.com.'. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID for Private Shared VPC. | `string` | n/a | yes |
| <a name="input_public_domain"></a> [public\_domain](#input\_public\_domain) | The organization's public domain (DNS), for instance 'example.com.'. | `string` | n/a | yes |
| <a name="input_allow_egress_ranges"></a> [allow\_egress\_ranges](#input\_allow\_egress\_ranges) | List of network ranges to which all egress traffic will be allowed | `list(string)` | `null` | no |
| <a name="input_allow_ingress_ranges"></a> [allow\_ingress\_ranges](#input\_allow\_ingress\_ranges) | List of network ranges from which all ingress traffic will be allowed | `list(string)` | `null` | no |
| <a name="input_data_subnets"></a> [data\_subnets](#input\_data\_subnets) | The list of data subnets being created | <pre>list(object({<br>    subnet_suffix = string<br>    subnet_range  = string<br>  }))</pre> | `[]` | no |
| <a name="input_dns_outbound_server_addresses"></a> [dns\_outbound\_server\_addresses](#input\_dns\_outbound\_server\_addresses) | List of IPv4 address of target name servers for the forwarding zone configuration. See https://cloud.google.com/dns/docs/overview#dns-forwarding-zones for details on target name servers in the context of Cloud DNS forwarding zones. | <pre>list(object({<br>    ipv4_address    = string,<br>    forwarding_path = string<br>  }))</pre> | `null` | no |
| <a name="input_enable_dns_inbound_forwarding"></a> [enable\_dns\_inbound\_forwarding](#input\_enable\_dns\_inbound\_forwarding) | Toggle inbound query forwarding for VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_dns_logging"></a> [enable\_dns\_logging](#input\_enable\_dns\_logging) | Toggle DNS logging for VPC DNS. | `bool` | `false` | no |
| <a name="input_enable_dns_outbound_forwarding"></a> [enable\_dns\_outbound\_forwarding](#input\_enable\_dns\_outbound\_forwarding) | Toggle outbound query forwarding for VPC DNS. if true dns\_outbound\_server\_addresses must be set | `bool` | `false` | no |
| <a name="input_enable_dns_peering"></a> [enable\_dns\_peering](#input\_enable\_dns\_peering) | Toggle inbound query forwarding for VPC DNS. | `bool` | `true` | no |
| <a name="input_enable_firewall_logging"></a> [enable\_firewall\_logging](#input\_enable\_firewall\_logging) | Toggle firewall logging for VPC Firewalls. | `bool` | `false` | no |
| <a name="input_enable_nat"></a> [enable\_nat](#input\_enable\_nat) | Toggle creation of NAT cloud router. | `bool` | `false` | no |
| <a name="input_enable_optional_fw_rules"></a> [enable\_optional\_fw\_rules](#input\_enable\_optional\_fw\_rules) | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges. | `bool` | `true` | no |
| <a name="input_enable_public_domain"></a> [enable\_public\_domain](#input\_enable\_public\_domain) | If true, a public domain zone will be created. | `bool` | `true` | no |
| <a name="input_enable_secure_web_proxy"></a> [enable\_secure\_web\_proxy](#input\_enable\_secure\_web\_proxy) | In hub mode, if enabled, a secure web proxy will be installed. | `bool` | `true` | no |
| <a name="input_enable_subnetworks_logging"></a> [enable\_subnetworks\_logging](#input\_enable\_subnetworks\_logging) | Toggle subnetworks flow logging for VPC Subnetworks. | `bool` | `false` | no |
| <a name="input_enable_transitive_network"></a> [enable\_transitive\_network](#input\_enable\_transitive\_network) | In hub mode, if enabled, a transit gateway will be installed. | `bool` | `true` | no |
| <a name="input_enable_windows_activation"></a> [enable\_windows\_activation](#input\_enable\_windows\_activation) | Enable Windows license activation for Windows workloads. | `bool` | `false` | no |
| <a name="input_infra_nethub_network_self_link"></a> [infra\_nethub\_network\_self\_link](#input\_infra\_nethub\_network\_self\_link) | Organization hub network VPC self link. Required in spoke mode | `string` | `null` | no |
| <a name="input_infra_nethub_project_id"></a> [infra\_nethub\_project\_id](#input\_infra\_nethub\_project\_id) | Organization hub network project. Required in spoke mode | `string` | `null` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Network deployment mode, should be set to `hub` or `spoke`. | `string` | `null` | no |
| <a name="input_nat_bgp_asn"></a> [nat\_bgp\_asn](#input\_nat\_bgp\_asn) | BGP ASN for first NAT cloud routes. | `number` | `64514` | no |
| <a name="input_nat_num_addresses"></a> [nat\_num\_addresses](#input\_nat\_num\_addresses) | Number of external IPs to reserve for first Cloud NAT. | `number` | `2` | no |
| <a name="input_private_service_cidr"></a> [private\_service\_cidr](#input\_private\_service\_cidr) | CIDR range for private service networking. Used for Cloud SQL and other managed services. | `string` | `null` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | The list of private subnets being created | <pre>list(object({<br>    subnet_suffix = string<br>    subnet_range  = string<br>  }))</pre> | `[]` | no |
| <a name="input_private_svc_connect_ip"></a> [private\_svc\_connect\_ip](#input\_private\_svc\_connect\_ip) | The internal IP to be used for the private service connect. Required for hub mode | `string` | `null` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | The list of public subnets being created | <pre>list(object({<br>    subnet_suffix = string<br>    subnet_range  = string<br>  }))</pre> | `[]` | no |
| <a name="input_reserved_subnets"></a> [reserved\_subnets](#input\_reserved\_subnets) | The list of reserved subnet for appliances like SVC and proxies. | <pre>map(object({<br>    purpose = string<br>    role    = string<br>    range   = string<br>  }))</pre> | `{}` | no |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | <pre>map(list(object({<br>    range_name    = string,<br>    ip_cidr_range = string<br>  })))</pre> | `{}` | no |
| <a name="input_shared_vpc_host"></a> [shared\_vpc\_host](#input\_shared\_vpc\_host) | If the Network will be shared with others projects | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
| <a name="output_subnets_ids"></a> [subnets\_ids](#output\_subnets\_ids) | The IDs of the subnets being created |
| <a name="output_subnets_names"></a> [subnets\_names](#output\_subnets\_names) | The names of the subnets being created |
| <a name="output_subnets_secondary_ranges"></a> [subnets\_secondary\_ranges](#output\_subnets\_secondary\_ranges) | The secondary ranges associated with these subnets |
| <a name="output_subnets_self_links"></a> [subnets\_self\_links](#output\_subnets\_self\_links) | The self-links of subnets being created |
<!-- END_TF_DOCS -->