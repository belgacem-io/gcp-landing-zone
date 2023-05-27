<!-- BEGIN_TF_DOCS -->
## Purpose

The purpose of this step is to bootstrap a Google cloud landing zone, creating all the required resources and
permissions.

## Prerequisites

Before stating, make sure that you've done the following:

1. Set up a Google Cloud [organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization).
2. Set up a Google Cloud [billing account](https://cloud.google.com/billing/docs/how-to/manage-billing-account).
3. Create Cloud Identity or Google Workspace groups for organization and billing admins.
4. Create a dedicated folder (optional, can use the organisation as container)
5. Create a bootstrap GCP project that will be used for running terraform scripts
6. Create a service account with the following permissions
    - organisation -> Billing Account Costs Manager
    - organisation -> Billing Account User
    - folder -> Owner
    - folder -> Project Creator
    - folder -> Security Admin
    - folder -> Service Account Token Creator
    - folder -> Service Account User
7. Create the following groups (optional)
    - xx-organization-admins@example.com
    - xx-security-admins@example.com
    - xx-security-reviewers@example.com
    - xx-billing-admins@example.com
    - xx-organization-viewers@example.com
    - xx-network-admins@example.com
    - xx-network-viewers@example.com
8. On bootstrap project, enable the flowing APIs
    - IAM Service Account Credentials API
    - Cloud Resource Manager API

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_billing_account"></a> [gcp\_billing\_account](#input\_gcp\_billing\_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_gcp_bootstrap_project_id"></a> [gcp\_bootstrap\_project\_id](#input\_gcp\_bootstrap\_project\_id) | The bootstrap project id. | `string` | n/a | yes |
| <a name="input_gcp_default_region"></a> [gcp\_default\_region](#input\_gcp\_default\_region) | Default region for resources. | `string` | n/a | yes |
| <a name="input_gcp_default_region_azs"></a> [gcp\_default\_region\_azs](#input\_gcp\_default\_region\_azs) | Default availability zones for region 1. | `list(string)` | n/a | yes |
| <a name="input_gcp_organization_domain"></a> [gcp\_organization\_domain](#input\_gcp\_organization\_domain) | The domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com | `string` | n/a | yes |
| <a name="input_gcp_organization_id"></a> [gcp\_organization\_id](#input\_gcp\_organization\_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_gcp_organization_name"></a> [gcp\_organization\_name](#input\_gcp\_organization\_name) | The organization name, will be used for resources naming. | `string` | n/a | yes |
| <a name="input_gcp_parent_container_id"></a> [gcp\_parent\_container\_id](#input\_gcp\_parent\_container\_id) | Can be either an organisation or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_email"></a> [gcp\_terraform\_sa\_email](#input\_gcp\_terraform\_sa\_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_id"></a> [gcp\_terraform\_sa\_id](#input\_gcp\_terraform\_sa\_id) | Service account id of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_group_org_admins"></a> [gcp\_group\_org\_admins](#input\_gcp\_group\_org\_admins) | Google Group for GCP Organization Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_billing_admins"></a> [gcp\_group\_org\_billing\_admins](#input\_gcp\_group\_org\_billing\_admins) | Google Group for GCP Organization Billing Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_network_admins"></a> [gcp\_group\_org\_network\_admins](#input\_gcp\_group\_org\_network\_admins) | Google Group for GCP Organization Network Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_network_viewers"></a> [gcp\_group\_org\_network\_viewers](#input\_gcp\_group\_org\_network\_viewers) | Google Group for GCP Organization Network Read only users | `string` | `null` | no |
| <a name="input_gcp_group_org_security_admins"></a> [gcp\_group\_org\_security\_admins](#input\_gcp\_group\_org\_security\_admins) | Google Group for GCP Organization Security Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_security_reviewers"></a> [gcp\_group\_org\_security\_reviewers](#input\_gcp\_group\_org\_security\_reviewers) | Google Group for GCP Organization Security reviewer | `string` | `null` | no |
| <a name="input_gcp_group_org_viewers"></a> [gcp\_group\_org\_viewers](#input\_gcp\_group\_org\_viewers) | Google Group for GCP Organization read only users | `string` | `null` | no |
| <a name="input_gcp_terraform_sa_org_iam_permissions"></a> [gcp\_terraform\_sa\_org\_iam\_permissions](#input\_gcp\_terraform\_sa\_org\_iam\_permissions) | List of permissions granted to Terraform service account across the GCP organization. | `list(string)` | <pre>[<br>  "roles/billing.user",<br>  "roles/compute.networkAdmin",<br>  "roles/compute.xpnAdmin",<br>  "roles/iam.securityAdmin",<br>  "roles/iam.serviceAccountAdmin",<br>  "roles/logging.configWriter",<br>  "roles/orgpolicy.policyAdmin",<br>  "roles/resourcemanager.folderAdmin",<br>  "roles/securitycenter.admin",<br>  "roles/iam.securityAdmin",<br>  "roles/monitoring.admin"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->