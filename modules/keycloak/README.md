<!-- BEGIN_TF_DOCS -->
# Keycloack Terraform module

[Terraform module](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs) which configures a realm of an exiting Keycloack instance

## Available Features

This module manage the following elements on realm cloud-public :
- global realm settings (Tokens TTL, ...)
- Authentication flow  X509Browser with MFA Support (X509 mandatory, OTP optionnal)
- user repository : LDAP with AD intra.${var.company_name}.local as ,
- AWS client, including :
  -  client roles, mapped on AWS accounts and roles,
  -  mappers needed to send required [SAML Assertions with AWS](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_saml_assertions.html)
- Users groups for each client roles (AWS role) on each AWS account

## Required environment variables

```bash
export KEYCLOAK_CLIENT_SECRET=xxxx-xxx-xxx-xxx-xxxxx
export KEYCLOAK_CLIENT_TIMEOUT=5
export TF_VAR_KEYCLOAK_LDAP_BIND_CREDENTIAL="xxxxxxxx"
```

## Usage

Add a [keycloak.tf](../../main-orga/keycloak.tf) file in your project, containing :

```hcl
module "keycloak" {
  source = "../modules/keycloak"

  keycloak_url        = "https://xxxxx.example.local"
  keycloak_realm      = "my-realm"
  keycloak_client_id       = "my-client"

  keycloak_ldap_server_url = "ldaps://xxxxx.example.local"
  keycloak_ldap_bind_dn    = "DC=intra,DC=example,DC=local"
  keycloak_ldap_users_dn   = "OU=USERS,DC=example,DC=local"
  keycloak_ldap_bind_credential     = "xxxxxxx"

  keycloak_ldap_roles_mapper_dn     = "DC=XXXX,DC=intra,DC=example,DC=local"
  keycloak_ldap_roles_mapper_filter = "(CN=XXXXX)"
  keycloak_ldap_roles_mapper_name   = "XXX Team"

  keycloak_roles = {
        ROLE_A = {
          name = "ROEL_A",
          group = "GROUP_A",
          account_id = "xxxxxx"
          account_name = "DEV"
        }
        ROLE_A = {
          name = "ROEL_B",
          group = "GROUP_B",
          account_id = "xxxxxx"
          account_name = "DEV"
        }
      }
  keycloak_ou_groups = {
        GROUP_A = {
          name = "GROUP_B",
          parent = "AWS"
        }
        GROUP_B = {
          name = "GROUP_A",
          parent = "GROUP_A"
        }
      }
  keycloak_account_groups = {
        ADMIN = {
          name = "ADMIN",
          parent = "GROUP_B"
        }
        DEVOPS = {
          name = "DEVOPS",
          parent = "GROUP_B"
        }
      }
}
```

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_keycloak"></a> [keycloak](#provider_keycloak) | >= 2.0.0 |

#### Modules

No modules.

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
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
| <a name="input_ldap_server_name"></a> [ldap_server_name](#input_ldap_server_name) | LDAP server name | `string` | n/a | yes |
| <a name="input_keycloak_account_groups"></a> [keycloak_account_groups](#input_keycloak_account_groups) | The map of groups to create. Defaults to an empty map. | <pre>map(object({<br>    name = string,<br>    parent = string<br>  }))</pre> | `{}` | no |
| <a name="input_keycloak_ou_groups"></a> [keycloak_ou_groups](#input_keycloak_ou_groups) | The map of groups to create. Defaults to an empty map. | <pre>map(object({<br>    name = string,<br>    parent = string<br>  }))</pre> | `{}` | no |
| <a name="input_keycloak_roles"></a> [keycloak_roles](#input_keycloak_roles) | The map of roles to create. Defaults to an empty dict. | <pre>map(object({<br>    name = string,<br>    group = string,<br>    account_id = string<br>    account_name = string<br>  }))</pre> | `{}` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_realm"></a> [realm](#output_realm) | n/a |
<!-- END_TF_DOCS -->