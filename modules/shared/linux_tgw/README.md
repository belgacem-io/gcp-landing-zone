<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region 1 for subnets and Cloud Routers | `string` | n/a | yes |
| <a name="input_destination_trusted_cidr_ranges"></a> [destination\_trusted\_cidr\_ranges](#input\_destination\_trusted\_cidr\_ranges) | Your internal/external CIDR range requiring access from this proxy. | `list(string)` | n/a | yes |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | The environment the single project belongs to | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The GCP VPC network name for the cluster to be built in. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project id of your GCP project | `string` | n/a | yes |
| <a name="input_source_trusted_cidr_ranges"></a> [source\_trusted\_cidr\_ranges](#input\_source\_trusted\_cidr\_ranges) | Your internal CIDR range requiring access to this proxy. | `list(string)` | n/a | yes |
| <a name="input_subnetwork_name"></a> [subnetwork\_name](#input\_subnetwork\_name) | The subnet in the VPC for the proxy cluster to be deployed to. | `string` | n/a | yes |
| <a name="input_authorized_members"></a> [authorized\_members](#input\_authorized\_members) | List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email} | `list(string)` | `[]` | no |
| <a name="input_autoscaling_cpu"></a> [autoscaling\_cpu](#input\_autoscaling\_cpu) | Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Creates an autoscaler for the managed instance group | `bool` | `false` | no |
| <a name="input_autoscaling_lb"></a> [autoscaling\_lb](#input\_autoscaling\_lb) | Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_metric"></a> [autoscaling\_metric](#input\_autoscaling\_metric) | Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric | <pre>list(object({<br>    name   = string<br>    target = number<br>    type   = string<br>  }))</pre> | `[]` | no |
| <a name="input_autoscaling_scale_in_control"></a> [autoscaling\_scale\_in\_control](#input\_autoscaling\_scale\_in\_control) | Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control | <pre>object({<br>    fixed_replicas   = number<br>    percent_replicas = number<br>    time_window_sec  = number<br>  })</pre> | <pre>{<br>  "fixed_replicas": 0,<br>  "percent_replicas": 30,<br>  "time_window_sec": 600<br>}</pre> | no |
| <a name="input_cooldown_period"></a> [cooldown\_period](#input\_cooldown\_period) | The number of seconds that the autoscaler should wait before it starts collecting information from a new instance. | `number` | `60` | no |
| <a name="input_firewall_enable_logging"></a> [firewall\_enable\_logging](#input\_firewall\_enable\_logging) | Toggle firewall logging for VPC Firewalls. | `bool` | `true` | no |
| <a name="input_instance_image"></a> [instance\_image](#input\_instance\_image) | The instance image. Must be debian base. | `string` | `"ubuntu-os-cloud/ubuntu-minimal-1804-lts"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type | `string` | `"e2-micro"` | no |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas. | `number` | `1` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. | `number` | `1` | no |
| <a name="input_network_tags"></a> [network\_tags](#input\_network\_tags) | Network tags for VMs. | `list(string)` | `[]` | no |
| <a name="input_update_policy"></a> [update\_policy](#input\_update\_policy) | The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager#rolling_update_policy | <pre>list(object({<br>    max_surge_fixed              = number<br>    instance_redistribution_type = string<br>    max_surge_percent            = number<br>    max_unavailable_fixed        = number<br>    max_unavailable_percent      = number<br>    min_ready_sec                = number<br>    replacement_method           = string<br>    minimal_action               = string<br>    type                         = string<br>  }))</pre> | <pre>[<br>  {<br>    "instance_redistribution_type": "NONE",<br>    "max_surge_fixed": 0,<br>    "max_surge_percent": null,<br>    "max_unavailable_fixed": 4,<br>    "max_unavailable_percent": null,<br>    "min_ready_sec": 180,<br>    "minimal_action": "RESTART",<br>    "replacement_method": "RECREATE",<br>    "type": "OPPORTUNISTIC"<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ilb_id"></a> [ilb\_id](#output\_ilb\_id) | n/a |
| <a name="output_proxy_service_accounts"></a> [proxy\_service\_accounts](#output\_proxy\_service\_accounts) | n/a |
<!-- END_TF_DOCS -->