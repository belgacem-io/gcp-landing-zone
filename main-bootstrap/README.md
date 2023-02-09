<!-- BEGIN_TF_DOCS -->
## Purpose
The purpose of this step is to bootstrap a Google cloud landing zone, creating all the required resources and permissions.

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

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_billing_account"></a> [gcp_billing_account](#input_gcp_billing_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_gcp_bootstrap_project_id"></a> [gcp_bootstrap_project_id](#input_gcp_bootstrap_project_id) | The bootstrap project id. | `string` | n/a | yes |
| <a name="input_gcp_default_region"></a> [gcp_default_region](#input_gcp_default_region) | Default region for resources. | `string` | n/a | yes |
| <a name="input_gcp_default_region_azs"></a> [gcp_default_region_azs](#input_gcp_default_region_azs) | Default availability zones for region 1. | `list(string)` | n/a | yes |
| <a name="input_gcp_organization_domain"></a> [gcp_organization_domain](#input_gcp_organization_domain) | The domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com | `string` | n/a | yes |
| <a name="input_gcp_organization_id"></a> [gcp_organization_id](#input_gcp_organization_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_gcp_parent_container_id"></a> [gcp_parent_container_id](#input_gcp_parent_container_id) | Can be either an organisation or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_email"></a> [gcp_terraform_sa_email](#input_gcp_terraform_sa_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_id"></a> [gcp_terraform_sa_id](#input_gcp_terraform_sa_id) | Service account id of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_group_org_admins"></a> [gcp_group_org_admins](#input_gcp_group_org_admins) | Google Group for GCP Organization Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_billing_admins"></a> [gcp_group_org_billing_admins](#input_gcp_group_org_billing_admins) | Google Group for GCP Organization Billing Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_network_admins"></a> [gcp_group_org_network_admins](#input_gcp_group_org_network_admins) | Google Group for GCP Organization Network Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_network_viewers"></a> [gcp_group_org_network_viewers](#input_gcp_group_org_network_viewers) | Google Group for GCP Organization Network Read only users | `string` | `null` | no |
| <a name="input_gcp_group_org_security_admins"></a> [gcp_group_org_security_admins](#input_gcp_group_org_security_admins) | Google Group for GCP Organization Security Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_security_reviewers"></a> [gcp_group_org_security_reviewers](#input_gcp_group_org_security_reviewers) | Google Group for GCP Organization Security reviewer | `string` | `null` | no |
| <a name="input_gcp_group_org_viewers"></a> [gcp_group_org_viewers](#input_gcp_group_org_viewers) | Google Group for GCP Organization read only users | `string` | `null` | no |
| <a name="input_gcp_terraform_sa_org_iam_permissions"></a> [gcp_terraform_sa_org_iam_permissions](#input_gcp_terraform_sa_org_iam_permissions) | List of permissions granted to Terraform service account across the GCP organization. | `list(string)` | <pre>[<br>  "roles/billing.user",<br>  "roles/compute.networkAdmin",<br>  "roles/compute.xpnAdmin",<br>  "roles/iam.securityAdmin",<br>  "roles/iam.serviceAccountAdmin",<br>  "roles/logging.configWriter",<br>  "roles/orgpolicy.policyAdmin",<br>  "roles/resourcemanager.folderAdmin",<br>  "roles/securitycenter.admin",<br>  "roles/iam.securityAdmin",<br>  "roles/monitoring.admin"<br>]</pre> | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->