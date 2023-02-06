<!-- BEGIN_TF_DOCS -->
#### Providers

No providers.

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_business_project"></a> [business_project](#module_business_project) | ../shared/gcp_single_project | n/a |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_apis"></a> [activate_apis](#input_activate_apis) | List of API to be enabled | `list(string)` | n/a | yes |
| <a name="input_billing_account"></a> [billing_account](#input_billing_account) | The ID of the billing account to associated this project with | `string` | n/a | yes |
| <a name="input_env_nethub_project_id"></a> [env_nethub_project_id](#input_env_nethub_project_id) | Environment hub network project id | `string` | n/a | yes |
| <a name="input_env_nethub_vpc_subnetwork_self_link"></a> [env_nethub_vpc_subnetwork_self_link](#input_env_nethub_vpc_subnetwork_self_link) | n/a | `list(string)` | n/a | yes |
| <a name="input_environment_code"></a> [environment_code](#input_environment_code) | A short form of the folder level resources (environment) within the Google Cloud organization (ex. d). | `string` | n/a | yes |
| <a name="input_monitoring_project_id"></a> [monitoring_project_id](#input_monitoring_project_id) | Monitoring project id | `string` | n/a | yes |
| <a name="input_org_id"></a> [org_id](#input_org_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_parent_folder_id"></a> [parent_folder_id](#input_parent_folder_id) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project_name](#input_project_name) | project name | `string` | n/a | yes |
| <a name="input_terraform_service_account"></a> [terraform_service_account](#input_terraform_service_account) | Service account email of the account to impersonate to run Terraform | `string` | n/a | yes |
| <a name="input_alert_pubsub_topic"></a> [alert_pubsub_topic](#input_alert_pubsub_topic) | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | `null` | no |
| <a name="input_alert_spent_percents"></a> [alert_spent_percents](#input_alert_spent_percents) | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| <a name="input_budget_amount"></a> [budget_amount](#input_budget_amount) | The amount to use as the budget | `number` | `1000` | no |
| <a name="input_default_region"></a> [default_region](#input_default_region) | Default region to create resources where applicable. | `string` | `"us-central1"` | no |
| <a name="input_firewall_enable_logging"></a> [firewall_enable_logging](#input_firewall_enable_logging) | Toggle firewall logging for VPC Firewalls. | `bool` | `true` | no |
| <a name="input_optional_fw_rules_enabled"></a> [optional_fw_rules_enabled](#input_optional_fw_rules_enabled) | Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges. | `bool` | `false` | no |
| <a name="input_peering_module_depends_on"></a> [peering_module_depends_on](#input_peering_module_depends_on) | List of modules or resources peering module depends on. | `list` | `[]` | no |
| <a name="input_windows_activation_enabled"></a> [windows_activation_enabled](#input_windows_activation_enabled) | Enable Windows license activation for Windows workloads. | `bool` | `false` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->