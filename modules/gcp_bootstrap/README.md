<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| <a name="input_group_billing_admins"></a> [group\_billing\_admins](#input\_group\_billing\_admins) | Google Group for GCP Billing Administrators | `string` | n/a | yes |
| <a name="input_group_org_admins"></a> [group\_org\_admins](#input\_group\_org\_admins) | Google Group for GCP Organization Administrators | `string` | n/a | yes |
| <a name="input_iac_service_account_email"></a> [iac\_service\_account\_email](#input\_iac\_service\_account\_email) | The service account that will be used by IaC chain. | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | GCP Organization ID | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | List of APIs to enable in the seed project. | `list(string)` | <pre>[<br>  "serviceusage.googleapis.com",<br>  "servicenetworking.googleapis.com",<br>  "compute.googleapis.com",<br>  "logging.googleapis.com",<br>  "bigquery.googleapis.com",<br>  "cloudresourcemanager.googleapis.com",<br>  "cloudbilling.googleapis.com",<br>  "iam.googleapis.com",<br>  "admin.googleapis.com",<br>  "appengine.googleapis.com",<br>  "storage-api.googleapis.com",<br>  "monitoring.googleapis.com",<br>  "billingbudgets.googleapis.com",<br>  "iamcredentials.googleapis.com",<br>  "pubsub.googleapis.com",<br>  "orgpolicy.googleapis.com"<br>]</pre> | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region to create resources where applicable. | `string` | `"us-central1"` | no |
| <a name="input_encrypt_gcs_bucket_tfstate"></a> [encrypt\_gcs\_bucket\_tfstate](#input\_encrypt\_gcs\_bucket\_tfstate) | Encrypt bucket used for storing terraform state files in seed project. | `bool` | `false` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The ID of a folder to host this project | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | If supplied, the state bucket will be deleted even while containing objects. | `bool` | `false` | no |
| <a name="input_grant_billing_user"></a> [grant\_billing\_user](#input\_grant\_billing\_user) | Grant roles/billing.user role to CFT service account | `bool` | `true` | no |
| <a name="input_key_protection_level"></a> [key\_protection\_level](#input\_key\_protection\_level) | The protection level to use when creating a version based on this template. Default value: "SOFTWARE" Possible values: ["SOFTWARE", "HSM"] | `string` | `"SOFTWARE"` | no |
| <a name="input_key_rotation_period"></a> [key\_rotation\_period](#input\_key\_rotation\_period) | The rotation period of the key. | `string` | `null` | no |
| <a name="input_kms_prevent_destroy"></a> [kms\_prevent\_destroy](#input\_kms\_prevent\_destroy) | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | `true` | no |
| <a name="input_org_admins_org_iam_permissions"></a> [org\_admins\_org\_iam\_permissions](#input\_org\_admins\_org\_iam\_permissions) | List of permissions granted to the group supplied in group\_org\_admins variable across the GCP organization. | `list(string)` | <pre>[<br>  "roles/billing.user",<br>  "roles/resourcemanager.organizationAdmin"<br>]</pre> | no |
| <a name="input_org_project_creators"></a> [org\_project\_creators](#input\_org\_project\_creators) | Additional list of members to have project creator role accross the organization. Prefix of group: user: or serviceAccount: is required. | `list(string)` | `[]` | no |
| <a name="input_parent_folder"></a> [parent\_folder](#input\_parent\_folder) | GCP parent folder ID in the form folders/{id} | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Custom project ID to use for project created. If not supplied, the default id is {project\_prefix}-seed-{random suffix}. | `string` | `""` | no |
| <a name="input_project_labels"></a> [project\_labels](#input\_project\_labels) | Labels to apply to the project. | `map(string)` | `{}` | no |
| <a name="input_random_suffix"></a> [random\_suffix](#input\_random\_suffix) | Appends a 4 character random suffix to project ID and GCS bucket name. | `bool` | `true` | no |
| <a name="input_sa_enable_impersonation"></a> [sa\_enable\_impersonation](#input\_sa\_enable\_impersonation) | Allow org\_admins group to impersonate service account & enable APIs required. | `bool` | `false` | no |
| <a name="input_sa_org_iam_permissions"></a> [sa\_org\_iam\_permissions](#input\_sa\_org\_iam\_permissions) | List of permissions granted to Terraform service account across the GCP organization. | `list(string)` | <pre>[<br>  "roles/compute.networkAdmin",<br>  "roles/compute.xpnAdmin",<br>  "roles/iam.securityAdmin",<br>  "roles/iam.serviceAccountAdmin",<br>  "roles/logging.configWriter",<br>  "roles/resourcemanager.folderAdmin",<br>  "roles/compute.xpnAdmin"<br>]</pre> | no |
| <a name="input_storage_bucket_labels"></a> [storage\_bucket\_labels](#input\_storage\_bucket\_labels) | Labels to apply to the storage bucket. | `map(string)` | `{}` | no |
| <a name="input_tf_service_account_id"></a> [tf\_service\_account\_id](#input\_tf\_service\_account\_id) | ID of service account for terraform in seed project | `string` | `"org-terraform"` | no |
| <a name="input_tf_service_account_name"></a> [tf\_service\_account\_name](#input\_tf\_service\_account\_name) | Display name of service account for terraform in seed project | `string` | `"CFT Organization Terraform Account"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->