<!-- BEGIN_TF_DOCS -->
## Purpose

This module essentially bootstraps an existing Google Cloud organization, setting up all the necessary Google Cloud resources and permissions to start utilizing a CFT. However, I've opted for a modification of the original version because it requires extensive permissions and access at the organizational level, which isn't always possible in some companies. The bootstrap step will use the current project for hosting two primary elements:
- Terraform State Bucket: This is where the Terraform state files are stored. These files are essential as they map resources to the configuration, keep track of metadata, and improve performance for large infrastructures.
- Custom Service Account: used by Terraform to create new resources in Google Cloud.

## Prerequisites

Before stating, make sure that you've done the following:

1. Set up a Google Cloud [organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization).
2. Set up a Google Cloud [billing account](https://cloud.google.com/billing/docs/how-to/manage-billing-account).
3. Create Cloud Identity or Google Workspace groups for organization and billing admins.
4. Create a dedicated folder (optional, can use the organization as container)
5. Create a bootstrap GCP project that will be used for running terraform scripts
6. Create a service account with the following permissions
    - organization -> Billing Account Costs Manager
    - organization -> Billing Account User
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
| <a name="input_gcp_labels"></a> [gcp\_labels](#input\_gcp\_labels) | Map of labels | `map(string)` | n/a | yes |
| <a name="input_gcp_org_id"></a> [gcp\_org\_id](#input\_gcp\_org\_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_gcp_org_name"></a> [gcp\_org\_name](#input\_gcp\_org\_name) | The organization name, will be used for resources naming. | `string` | n/a | yes |
| <a name="input_gcp_org_private_domain"></a> [gcp\_org\_private\_domain](#input\_gcp\_org\_private\_domain) | The private domain of the current organization. Can be different from the organization name. exp:  company.local, cloud.company.local | `string` | n/a | yes |
| <a name="input_gcp_org_public_domain"></a> [gcp\_org\_public\_domain](#input\_gcp\_org\_public\_domain) | The public domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com | `string` | n/a | yes |
| <a name="input_gcp_parent_container_id"></a> [gcp\_parent\_container\_id](#input\_gcp\_parent\_container\_id) | Can be either an organization or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_email"></a> [gcp\_terraform\_sa\_email](#input\_gcp\_terraform\_sa\_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_group_org_admins"></a> [gcp\_group\_org\_admins](#input\_gcp\_group\_org\_admins) | Google Group for GCP Organization Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_billing_admins"></a> [gcp\_group\_org\_billing\_admins](#input\_gcp\_group\_org\_billing\_admins) | Google Group for GCP Organization Billing Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_network_admins"></a> [gcp\_group\_org\_network\_admins](#input\_gcp\_group\_org\_network\_admins) | Google Group for GCP Organization Network Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_network_viewers"></a> [gcp\_group\_org\_network\_viewers](#input\_gcp\_group\_org\_network\_viewers) | Google Group for GCP Organization Network Read only users | `string` | `null` | no |
| <a name="input_gcp_group_org_security_admins"></a> [gcp\_group\_org\_security\_admins](#input\_gcp\_group\_org\_security\_admins) | Google Group for GCP Organization Security Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_security_reviewers"></a> [gcp\_group\_org\_security\_reviewers](#input\_gcp\_group\_org\_security\_reviewers) | Google Group for GCP Organization Security reviewer | `string` | `null` | no |
| <a name="input_gcp_group_org_viewers"></a> [gcp\_group\_org\_viewers](#input\_gcp\_group\_org\_viewers) | Google Group for GCP Organization read only users | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->