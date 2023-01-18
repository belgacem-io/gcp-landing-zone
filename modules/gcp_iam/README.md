<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 4.5 |
| <a name="provider_googleworkspace"></a> [googleworkspace](#provider_googleworkspace) | n/a |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_folders_iam_bindings"></a> [folders_iam_bindings](#module_folders_iam_bindings) | terraform-google-modules/iam/google//modules/folders_iam | ~> 6.4 |
| <a name="module_organization_iam_groups"></a> [organization_iam_groups](#module_organization_iam_groups) | terraform-google-modules/group/google | ~> 0.1 |
| <a name="module_organization_iam_groups_bindings"></a> [organization_iam_groups_bindings](#module_organization_iam_groups_bindings) | terraform-google-modules/iam/google//modules/organizations_iam | n/a |
| <a name="module_projects_iam_bindings"></a> [projects_iam_bindings](#module_projects_iam_bindings) | terraform-google-modules/iam/google//modules/projects_iam | ~> 6.4 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_super_admins"></a> [default_super_admins](#input_default_super_admins) | Default organization super admins | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input_domain) | Organization domain | `string` | n/a | yes |
| <a name="input_iam_users"></a> [iam_users](#input_iam_users) | IAM users to import to workspace | <pre>map(object({<br>    given_name  = string<br>    family_name = string<br>    email       = string<br>  }))</pre> | n/a | yes |
| <a name="input_organization_id"></a> [organization_id](#input_organization_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_folder_iam_groups"></a> [folder_iam_groups](#input_folder_iam_groups) | Organization groups  at folder level | <pre>map(object({<br>    name     = string<br>    email    = string<br>    folders  = list(string)<br>    roles    = list(string)<br>    members  = list(string)<br>    managers = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_iam_groups"></a> [iam_groups](#input_iam_groups) | Organization groups to create | <pre>map(object({<br>    name     = string<br>    email    = string<br>    members  = list(string)<br>    managers = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_organization_iam_groups"></a> [organization_iam_groups](#input_organization_iam_groups) | Organization groups/roles at organization level | <pre>map(object({<br>    name     = string<br>    email    = string<br>    roles    = list(string)<br>    members  = list(string)<br>    managers = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_project_iam_groups"></a> [project_iam_groups](#input_project_iam_groups) | Organization groups  at project level | <pre>map(object({<br>    name     = string<br>    email    = string<br>    projects = list(string)<br>    roles    = list(string)<br>    members  = list(string)<br>    managers = list(string)<br>  }))</pre> | `{}` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_folder_iam_groups_bindings"></a> [folder_iam_groups_bindings](#output_folder_iam_groups_bindings) | n/a |
| <a name="output_folders"></a> [folders](#output_folders) | n/a |
| <a name="output_organization_iam_groups_bindings"></a> [organization_iam_groups_bindings](#output_organization_iam_groups_bindings) | n/a |
| <a name="output_project_iam_groups_bindings"></a> [project_iam_groups_bindings](#output_project_iam_groups_bindings) | n/a |
| <a name="output_projects"></a> [projects](#output_projects) | n/a |
<!-- END_TF_DOCS -->