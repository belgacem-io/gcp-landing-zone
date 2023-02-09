<!-- BEGIN_TF_DOCS -->
#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_members"></a> [authorized_members](#input_authorized_members) | List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email} | `list(string)` | n/a | yes |
| <a name="input_environment_code"></a> [environment_code](#input_environment_code) | A short form of the folder level resources (environment) within the Google Cloud organization. | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance_name](#input_instance_name) | Name of the VM instance to create and allow SSH from IAP. | `string` | n/a | yes |
| <a name="input_network_self_link"></a> [network_self_link](#input_network_self_link) | Network where to install the bastion host | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project_id](#input_project_id) | Project ID where to set up the instance and IAP tunneling | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input_region) | Region to create the subnet and VM. | `string` | n/a | yes |
| <a name="input_subnet_self_link"></a> [subnet_self_link](#input_subnet_self_link) | Subnet where to install the bastion host | `string` | n/a | yes |
| <a name="input_autoscaling_cpu"></a> [autoscaling_cpu](#input_autoscaling_cpu) | Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling_enabled](#input_autoscaling_enabled) | Creates an autoscaler for the managed instance group | `bool` | `false` | no |
| <a name="input_autoscaling_lb"></a> [autoscaling_lb](#input_autoscaling_lb) | Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_metric"></a> [autoscaling_metric](#input_autoscaling_metric) | Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric | <pre>list(object({<br>    name   = string<br>    target = number<br>    type   = string<br>  }))</pre> | `[]` | no |
| <a name="input_autoscaling_scale_in_control"></a> [autoscaling_scale_in_control](#input_autoscaling_scale_in_control) | Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control | <pre>object({<br>    fixed_replicas   = number<br>    percent_replicas = number<br>    time_window_sec  = number<br>  })</pre> | <pre>{<br>  "fixed_replicas": 0,<br>  "percent_replicas": 30,<br>  "time_window_sec": 600<br>}</pre> | no |
| <a name="input_cooldown_period"></a> [cooldown_period](#input_cooldown_period) | The number of seconds that the autoscaler should wait before it starts collecting information from a new instance. | `number` | `60` | no |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type) | Type of the VM instance to create and allow SSH from IAP. | `string` | `"e2-micro"` | no |
| <a name="input_max_replicas"></a> [max_replicas](#input_max_replicas) | The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas. | `number` | `1` | no |
| <a name="input_min_replicas"></a> [min_replicas](#input_min_replicas) | The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. | `number` | `1` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->