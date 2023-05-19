<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | List of API to be enabled | `list(string)` | n/a | yes |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associated this project with | `string` | n/a | yes |
| <a name="input_env_nethub_project_id"></a> [env\_nethub\_project\_id](#input\_env\_nethub\_project\_id) | Environment hub network project id | `string` | n/a | yes |
| <a name="input_env_nethub_vpc_subnetwork_self_link"></a> [env\_nethub\_vpc\_subnetwork\_self\_link](#input\_env\_nethub\_vpc\_subnetwork\_self\_link) | n/a | `list(string)` | n/a | yes |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | A short form of the folder level resources (environment) within the Google Cloud organization (ex. d). | `string` | n/a | yes |
| <a name="input_monitoring_project_id"></a> [monitoring\_project\_id](#input\_monitoring\_project\_id) | Monitoring project id | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_parent_folder_id"></a> [parent\_folder\_id](#input\_parent\_folder\_id) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | project name | `string` | n/a | yes |
| <a name="input_terraform_service_account"></a> [terraform\_service\_account](#input\_terraform\_service\_account) | Service account email of the account to impersonate to run Terraform | `string` | n/a | yes |
| <a name="input_alert_pubsub_topic"></a> [alert\_pubsub\_topic](#input\_alert\_pubsub\_topic) | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | `null` | no |
| <a name="input_alert_spent_percents"></a> [alert\_spent\_percents](#input\_alert\_spent\_percents) | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| <a name="input_budget_amount"></a> [budget\_amount](#input\_budget\_amount) | The amount to use as the budget | `number` | `1000` | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region to create resources where applicable. | `string` | `"us-central1"` | no |
| <a name="input_firewall_enable_logging"></a> [firewall\_enable\_logging](#input\_firewall\_enable\_logging) | Toggle firewall logging for VPC Firewalls. | `bool` | `true` | no |
| <a name="input_optional_fw_rules_enabled"></a> [optional\_fw\_rules\_enabled](#input\_optional\_fw\_rules\_enabled) | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges. | `bool` | `false` | no |
| <a name="input_peering_module_depends_on"></a> [peering\_module\_depends\_on](#input\_peering\_module\_depends\_on) | List of modules or resources peering module depends on. | `list` | `[]` | no |
| <a name="input_windows_activation_enabled"></a> [windows\_activation\_enabled](#input\_windows\_activation\_enabled) | Enable Windows license activation for Windows workloads. | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->