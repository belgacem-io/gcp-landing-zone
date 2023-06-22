<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region 1 for subnets and Cloud Routers | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The organization name, will be used for resources naming. | `string` | n/a | yes |
| <a name="input_parent_container_id"></a> [parent\_container\_id](#input\_parent\_container\_id) | Can be either an organization or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_folders_by_env_code"></a> [folders\_by\_env\_code](#output\_folders\_by\_env\_code) | n/a |
| <a name="output_netenv_networks_by_env_code"></a> [netenv\_networks\_by\_env\_code](#output\_netenv\_networks\_by\_env\_code) | n/a |
| <a name="output_netenv_projects_by_env_code"></a> [netenv\_projects\_by\_env\_code](#output\_netenv\_projects\_by\_env\_code) | n/a |
| <a name="output_projects_by_name"></a> [projects\_by\_name](#output\_projects\_by\_name) | n/a |
<!-- END_TF_DOCS -->