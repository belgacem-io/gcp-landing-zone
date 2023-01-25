# Hub & Spoke Transitivity module

This module implements transitivity for hub & spoke VPC architectures using appliance VMs behind an
Internal Load Balancer used as next-hop for routes.

## Usage

For example usage, please check the the [net-hubs-transitivity.tf](../../envs/shared/net-hubs-transitivity.tf) file.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| commands | Commands for the transitivity gateway to run on every boot. | `list(string)` | `[]` | no |
| firewall\_enable\_logging | Toggle firewall logging for VPC Firewalls. | `bool` | `true` | no |
| gw\_subnets | Subnets in {REGION => SUBNET} format. | `map(string)` | n/a | yes |
| health\_check\_enable\_log | Toggle logging for health checks. | `bool` | `false` | no |
| project\_id | VPC Project ID | `string` | n/a | yes |
| regional\_aggregates | Aggregate ranges for each region in {REGION => [AGGREGATE\_CIDR,] } format. | `map(list(string))` | n/a | yes |
| regions | Regions to deploy the transitivity appliances | `set(string)` | `null` | no |
| vpc\_name | Label to identify the VPC associated with shared VPC that will use the Interconnect. | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 4.0, < 5.0 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_service_connect"></a> [private_service_connect](#module_private_service_connect) | terraform-google-modules/network/google//modules/private-service-connect | ~> 5.2 |
| <a name="module_transitivity_gateway"></a> [transitivity_gateway](#module_transitivity_gateway) | ../squid_proxy | n/a |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default_region](#input_default_region) | Default region 1 for subnets and Cloud Routers | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment_code](#input_environment_code) | The environment the single project belongs to | `string` | n/a | yes |
| <a name="input_mode"></a> [mode](#input_mode) | Network deployment mode, should be set to `hub` or `spoke`. | `string` | n/a | yes |
| <a name="input_network_name"></a> [network_name](#input_network_name) | The GCP VPC network name for the cluster to be built in. | `string` | n/a | yes |
| <a name="input_network_self_link"></a> [network_self_link](#input_network_self_link) | The GCP VPC network link for the cluster to be built in. | `string` | n/a | yes |
| <a name="input_private_svc_connect_subnets_ids"></a> [private_svc_connect_subnets_ids](#input_private_svc_connect_subnets_ids) | The list of subnets where service Private Service Connect will be published. | `list(string)` | n/a | yes |
| <a name="input_project_id"></a> [project_id](#input_project_id) | VPC Project ID | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet_name](#input_subnet_name) | The subnet in the VPC for the proxy cluster to be deployed to. | `string` | n/a | yes |
| <a name="input_internal_trusted_cidr_ranges"></a> [internal_trusted_cidr_ranges](#input_internal_trusted_cidr_ranges) | Internal trusted ip ranges. Must be set to private ip ranges | `list(string)` | <pre>[<br>  "10.0.0.0/8",<br>  "172.16.0.0/12",<br>  "192.168.0.0/16"<br>]</pre> | no |
| <a name="input_private_svc_connect_ip"></a> [private_svc_connect_ip](#input_private_svc_connect_ip) | The internal IP to be used for the private service connect. Required for hub mode | `string` | `null` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->