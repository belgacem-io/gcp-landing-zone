<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_members"></a> [authorized\_members](#input\_authorized\_members) | List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email} | `list(string)` | n/a | yes |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | A short form of the folder level resources (environment) within the Google Cloud organization. | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the VM instance to create and allow SSH from IAP. | `string` | n/a | yes |
| <a name="input_network_self_link"></a> [network\_self\_link](#input\_network\_self\_link) | Network where to install the bastion host | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID where to set up the instance and IAP tunneling | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to create the subnet and VM. | `string` | n/a | yes |
| <a name="input_subnet_self_link"></a> [subnet\_self\_link](#input\_subnet\_self\_link) | Subnet where to install the bastion host | `string` | n/a | yes |
| <a name="input_autoscaling_cpu"></a> [autoscaling\_cpu](#input\_autoscaling\_cpu) | Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Creates an autoscaler for the managed instance group | `bool` | `false` | no |
| <a name="input_autoscaling_lb"></a> [autoscaling\_lb](#input\_autoscaling\_lb) | Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_metric"></a> [autoscaling\_metric](#input\_autoscaling\_metric) | Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric | <pre>list(object({<br>    name   = string<br>    target = number<br>    type   = string<br>  }))</pre> | `[]` | no |
| <a name="input_autoscaling_scale_in_control"></a> [autoscaling\_scale\_in\_control](#input\_autoscaling\_scale\_in\_control) | Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control | <pre>object({<br>    fixed_replicas   = number<br>    percent_replicas = number<br>    time_window_sec  = number<br>  })</pre> | <pre>{<br>  "fixed_replicas": 0,<br>  "percent_replicas": 30,<br>  "time_window_sec": 600<br>}</pre> | no |
| <a name="input_cooldown_period"></a> [cooldown\_period](#input\_cooldown\_period) | The number of seconds that the autoscaler should wait before it starts collecting information from a new instance. | `number` | `60` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the VM instance to create and allow SSH from IAP. | `string` | `"e2-micro"` | no |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas. | `number` | `1` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. | `number` | `1` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->