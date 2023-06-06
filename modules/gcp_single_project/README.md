<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name                                   | Description                                                                                                                                   | Type           | Default                                                    | Required |
|----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|----------------|------------------------------------------------------------|:--------:|
| activate\_apis                         | The api to activate for the GCP project                                                                                                       | `list(string)` | `[]`                                                       |    no    |
| alert\_pubsub\_topic                   | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string`       | `null`                                                     |    no    |
| alert\_spent\_percents                 | A list of percentages of the budget to alert on when threshold is exceeded                                                                    | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> |    no    |
| application\_name                      | The name of application where GCP resources relate                                                                                            | `string`       | n/a                                                        |   yes    |
| billing\_account                       | The ID of the billing account to associated this project with                                                                                 | `string`       | n/a                                                        |   yes    |
| billing\_code                          | The code that's used to provide chargeback information                                                                                        | `string`       | n/a                                                        |   yes    |
| budget\_amount                         | The amount to use as the budget                                                                                                               | `number`       | `1000`                                                     |    no    |
| business\_code                         | The code that describes which business unit owns the project                                                                                  | `string`       | `"abcd"`                                                   |    no    |
| cloudbuild\_sa                         | The Cloud Build SA used for deploying infrastructure in this project. It will impersonate the new default SA created                          | `string`       | `""`                                                       |    no    |
| enable\_cloudbuild\_deploy             | Enable infra deployment using Cloud Build                                                                                                     | `bool`         | `false`                                                    |    no    |
| enable\_hub\_and\_spoke                | Enable Hub-and-Spoke architecture.                                                                                                            | `bool`         | `false`                                                    |    no    |
| environment                            | The environment the single project belongs to                                                                                                 | `string`       | n/a                                                        |   yes    |
| folder\_id                             | The folder id where project will be created                                                                                                   | `string`       | n/a                                                        |   yes    |
| impersonate\_service\_account          | Service account email of the account to impersonate to run Terraform                                                                          | `string`       | n/a                                                        |   yes    |
| org\_id                                | The organization id for the associated services                                                                                               | `string`       | n/a                                                        |   yes    |
| primary\_contact                       | The primary email contact for the project                                                                                                     | `string`       | n/a                                                        |   yes    |
| project\_prefix                        | Name prefix to use for projects created.                                                                                                      | `string`       | `"prj"`                                                    |    no    |
| project\_suffix                        | The name of the GCP project. Max 16 characters with 3 character business unit code.                                                           | `string`       | n/a                                                        |   yes    |
| sa\_roles                              | A list of roles to give the Service Account for the project (defaults to none)                                                                | `list(string)` | `[]`                                                       |    no    |
| secondary\_contact                     | The secondary email contact for the project                                                                                                   | `string`       | `""`                                                       |    no    |
| vpc\_service\_control\_attach\_enabled | Whether the project will be attached to a VPC Service Control Perimeter                                                                       | `bool`         | `false`                                                    |    no    |
| vpc\_service\_control\_perimeter\_name | The name of a VPC Service Control Perimeter to add the created project to                                                                     | `string`       | `null`                                                     |    no    |
| vpc\_type                              | The type of VPC to attach the project to. Possible options are base or restricted.                                                            | `string`       | `""`                                                       |    no    |

## Outputs

| Name            | Description                    |
|-----------------|--------------------------------|
| enabled\_apis   | VPC Service Control services.  |
| project\_id     | Project sample project id.     |
| project\_number | Project sample project number. |
| sa              | Project SA email               |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | The environment the single project belongs to | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The folder id where project will be created | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Map of labels | `map(string)` | n/a | yes |
| <a name="input_monitoring_project_id"></a> [monitoring\_project\_id](#input\_monitoring\_project\_id) | Monitoring project id | `string` | n/a | yes |
| <a name="input_netenv_project_id"></a> [netenv\_project\_id](#input\_netenv\_project\_id) | Environment hub network project id | `string` | n/a | yes |
| <a name="input_netenv_subnet_self_link"></a> [netenv\_subnet\_self\_link](#input\_netenv\_subnet\_self\_link) | n/a | `any` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | project name | `string` | n/a | yes |
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | The api to activate for the GCP project | `list(string)` | `[]` | no |
| <a name="input_alert_pubsub_topic"></a> [alert\_pubsub\_topic](#input\_alert\_pubsub\_topic) | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | `null` | no |
| <a name="input_alert_spent_percents"></a> [alert\_spent\_percents](#input\_alert\_spent\_percents) | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associated this project with | `string` | `null` | no |
| <a name="input_budget_amount"></a> [budget\_amount](#input\_budget\_amount) | The amount to use as the budget | `number` | `1000` | no |
| <a name="input_vpc_service_control_attach_enabled"></a> [vpc\_service\_control\_attach\_enabled](#input\_vpc\_service\_control\_attach\_enabled) | Whether the project will be attached to a VPC Service Control Perimeter | `bool` | `false` | no |
| <a name="input_vpc_service_control_perimeter_name"></a> [vpc\_service\_control\_perimeter\_name](#input\_vpc\_service\_control\_perimeter\_name) | The name of a VPC Service Control Perimeter to add the created project to | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled_apis"></a> [enabled\_apis](#output\_enabled\_apis) | VPC Service Control services. |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Project sample project id. |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | Project sample project number. |
| <a name="output_sa"></a> [sa](#output\_sa) | Project SA email |
<!-- END_TF_DOCS -->