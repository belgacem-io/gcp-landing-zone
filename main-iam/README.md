<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google.impersonate"></a> [google.impersonate](#provider_google.impersonate) | >= 4.5 |
| <a name="provider_keycloak"></a> [keycloak](#provider_keycloak) | >= 2.0.0 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp_iam"></a> [gcp_iam](#module_gcp_iam) | ../modules/gcp_iam | n/a |
| <a name="module_keycloak"></a> [keycloak](#module_keycloak) | ../modules/keycloak | n/a |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_billing_account"></a> [gcp_billing_account](#input_gcp_billing_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_gcp_group_org_admins"></a> [gcp_group_org_admins](#input_gcp_group_org_admins) | Google Group for GCP Organization Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_billing_admins"></a> [gcp_group_org_billing_admins](#input_gcp_group_org_billing_admins) | Google Group for GCP Organization Billing Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_network_admins"></a> [gcp_group_org_network_admins](#input_gcp_group_org_network_admins) | Google Group for GCP Organization Network Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_network_viewers"></a> [gcp_group_org_network_viewers](#input_gcp_group_org_network_viewers) | Google Group for GCP Organization Network Read only users | `string` | n/a | yes |
| <a name="input_gcp_group_org_security_admins"></a> [gcp_group_org_security_admins](#input_gcp_group_org_security_admins) | Google Group for GCP Organization Security Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_security_reviewers"></a> [gcp_group_org_security_reviewers](#input_gcp_group_org_security_reviewers) | Google Group for GCP Organization Security reviewer | `string` | n/a | yes |
| <a name="input_gcp_group_org_viewers"></a> [gcp_group_org_viewers](#input_gcp_group_org_viewers) | Google Group for GCP Organization read only users | `string` | n/a | yes |
| <a name="input_gcp_iam_groups"></a> [gcp_iam_groups](#input_gcp_iam_groups) | Organization groups at the organization level | <pre>map(object({<br>    folders    = list(string)<br>    projects   = list(string)<br>    name       = string<br>    roles      = list(string)<br>    members    = list(string)<br>    managers   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_gcp_organization_domain"></a> [gcp_organization_domain](#input_gcp_organization_domain) | The domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com | `string` | n/a | yes |
| <a name="input_gcp_organization_id"></a> [gcp_organization_id](#input_gcp_organization_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_email"></a> [gcp_terraform_sa_email](#input_gcp_terraform_sa_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_id"></a> [gcp_terraform_sa_id](#input_gcp_terraform_sa_id) | Service account id of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_workspace_customer_id"></a> [gcp_workspace_customer_id](#input_gcp_workspace_customer_id) | The ID of the customer account associated with your organization | `string` | n/a | yes |
| <a name="input_keycloak_client_id"></a> [keycloak_client_id](#input_keycloak_client_id) | keycloak client id | `string` | n/a | yes |
| <a name="input_keycloak_ldap_bind_credential"></a> [keycloak_ldap_bind_credential](#input_keycloak_ldap_bind_credential) | Ldap admin credential | `string` | n/a | yes |
| <a name="input_keycloak_ldap_bind_dn"></a> [keycloak_ldap_bind_dn](#input_keycloak_ldap_bind_dn) | Ldap admin DN | `string` | n/a | yes |
| <a name="input_keycloak_ldap_roles_mapper_dn"></a> [keycloak_ldap_roles_mapper_dn](#input_keycloak_ldap_roles_mapper_dn) | Ldap roles mapper DN | `string` | n/a | yes |
| <a name="input_keycloak_ldap_roles_mapper_filter"></a> [keycloak_ldap_roles_mapper_filter](#input_keycloak_ldap_roles_mapper_filter) | Ldap roles mapper filter | `string` | n/a | yes |
| <a name="input_keycloak_ldap_roles_mapper_name"></a> [keycloak_ldap_roles_mapper_name](#input_keycloak_ldap_roles_mapper_name) | Ldap roles mapper name | `string` | n/a | yes |
| <a name="input_keycloak_ldap_server_url"></a> [keycloak_ldap_server_url](#input_keycloak_ldap_server_url) | Ldap server URL | `string` | n/a | yes |
| <a name="input_keycloak_ldap_users_dn"></a> [keycloak_ldap_users_dn](#input_keycloak_ldap_users_dn) | Ldap users DN | `string` | n/a | yes |
| <a name="input_keycloak_realm"></a> [keycloak_realm](#input_keycloak_realm) | keycloak realm name | `string` | n/a | yes |
| <a name="input_keycloak_url"></a> [keycloak_url](#input_keycloak_url) | keycloak instance url | `string` | n/a | yes |
| <a name="input_gcp_labels"></a> [gcp_labels](#input_gcp_labels) | Map of tags | `map(string)` | `{}` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->