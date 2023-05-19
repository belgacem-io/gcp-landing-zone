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
## Organization policies

To manage organization policies, the `orgpolicy.googleapis.com` service should be enabled in the quota project.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domains_to_allow"></a> [domains\_to\_allow](#input\_domains\_to\_allow) | The list of domains to allow users from in IAM. Used by Domain Restricted Sharing Organization Policy. Must include the domain of the organization you are deploying the foundation. To add other domains you must also grant access to these domains to the terraform service account used in the deploy. | `list(string)` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | Resource id where the policies must be applied | `string` | n/a | yes |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | Resource type where the policies must be applied. Possible values: organization, folder and project | `string` | n/a | yes |
| <a name="input_create_access_context_manager_access_policy"></a> [create\_access\_context\_manager\_access\_policy](#input\_create\_access\_context\_manager\_access\_policy) | Whether to create access context manager access policy | `bool` | `false` | no |
| <a name="input_disable_automatic_iam_grants_on_default_service_accounts_policy"></a> [disable\_automatic\_iam\_grants\_on\_default\_service\_accounts\_policy](#input\_disable\_automatic\_iam\_grants\_on\_default\_service\_accounts\_policy) | Disable automatic IAM grants on default service accounts Organization Policy. | `bool` | `false` | no |
| <a name="input_disable_guest_attributes_access_policy"></a> [disable\_guest\_attributes\_access\_policy](#input\_disable\_guest\_attributes\_access\_policy) | Disable guest attributes access Organization Policy. | `bool` | `false` | no |
| <a name="input_disable_nested_virtualization_policy"></a> [disable\_nested\_virtualization\_policy](#input\_disable\_nested\_virtualization\_policy) | Disable nested virtualization Organization Policy. | `bool` | `false` | no |
| <a name="input_disable_serial_port_access_policy"></a> [disable\_serial\_port\_access\_policy](#input\_disable\_serial\_port\_access\_policy) | Disable serial port access Organization Policy. | `bool` | `false` | no |
| <a name="input_enable_cloudsql_external_ip_access_policy"></a> [enable\_cloudsql\_external\_ip\_access\_policy](#input\_enable\_cloudsql\_external\_ip\_access\_policy) | Enable Cloud SQL external IP Organization Policy. | `bool` | `false` | no |
| <a name="input_enable_domains_sharing_restriction_policy"></a> [enable\_domains\_sharing\_restriction\_policy](#input\_enable\_domains\_sharing\_restriction\_policy) | Enable domains sharing restriction Organization Policy. | `bool` | `false` | no |
| <a name="input_enable_os_login_policy"></a> [enable\_os\_login\_policy](#input\_enable\_os\_login\_policy) | Require os login Organization Policy. | `bool` | `false` | no |
| <a name="input_enable_sa_key_creation_deny_policy"></a> [enable\_sa\_key\_creation\_deny\_policy](#input\_enable\_sa\_key\_creation\_deny\_policy) | Deny service account key creation at the organization level. | `bool` | `false` | no |
| <a name="input_enforce_bucket_level_access_policy"></a> [enforce\_bucket\_level\_access\_policy](#input\_enforce\_bucket\_level\_access\_policy) | Enforce bucket level access Organization Policy. | `bool` | `false` | no |
| <a name="input_shared_vpc_lien_removal_policy"></a> [shared\_vpc\_lien\_removal\_policy](#input\_shared\_vpc\_lien\_removal\_policy) | Shared vpc lien removal Organization Policy. | `bool` | `false` | no |
| <a name="input_skip_default_network_policy"></a> [skip\_default\_network\_policy](#input\_skip\_default\_network\_policy) | Skip default network Organization Policy. | `bool` | `false` | no |
| <a name="input_vm_external_ip_access_policy"></a> [vm\_external\_ip\_access\_policy](#input\_vm\_external\_ip\_access\_policy) | vm external ip\_access Organization Policy. | `list(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->