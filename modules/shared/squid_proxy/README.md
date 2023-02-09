<!-- BEGIN_TF_DOCS -->
#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default_region](#input_default_region) | Default region 1 for subnets and Cloud Routers | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment_code](#input_environment_code) | The environment the single project belongs to | `string` | n/a | yes |
| <a name="input_internal_trusted_cidr_ranges"></a> [internal_trusted_cidr_ranges](#input_internal_trusted_cidr_ranges) | Your internal CIDR range requiring access to this proxy. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | Root name that all cloud objects will be named with. | `string` | n/a | yes |
| <a name="input_network_internet_egress_tag"></a> [network_internet_egress_tag](#input_network_internet_egress_tag) | Network tags for VMs with internet access. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project_id](#input_project_id) | The project id of your GCP project | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet_name](#input_subnet_name) | The subnet in the VPC for the proxy cluster to be deployed to. | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc_name](#input_vpc_name) | The GCP VPC network name for the cluster to be built in. | `string` | n/a | yes |
| <a name="input_authorized_ports"></a> [authorized_ports](#input_authorized_ports) | List of safe ports. | `list(string)` | <pre>[<br>  "80",<br>  "443",<br>  "21",<br>  "3128"<br>]</pre> | no |
| <a name="input_autoscaling_cpu"></a> [autoscaling_cpu](#input_autoscaling_cpu) | Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling_enabled](#input_autoscaling_enabled) | Creates an autoscaler for the managed instance group | `bool` | `false` | no |
| <a name="input_autoscaling_lb"></a> [autoscaling_lb](#input_autoscaling_lb) | Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_metric"></a> [autoscaling_metric](#input_autoscaling_metric) | Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric | <pre>list(object({<br>    name   = string<br>    target = number<br>    type   = string<br>  }))</pre> | `[]` | no |
| <a name="input_autoscaling_scale_in_control"></a> [autoscaling_scale_in_control](#input_autoscaling_scale_in_control) | Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control | <pre>object({<br>    fixed_replicas   = number<br>    percent_replicas = number<br>    time_window_sec  = number<br>  })</pre> | <pre>{<br>  "fixed_replicas": 0,<br>  "percent_replicas": 30,<br>  "time_window_sec": 600<br>}</pre> | no |
| <a name="input_cooldown_period"></a> [cooldown_period](#input_cooldown_period) | The number of seconds that the autoscaler should wait before it starts collecting information from a new instance. | `number` | `60` | no |
| <a name="input_firewall_enable_logging"></a> [firewall_enable_logging](#input_firewall_enable_logging) | Toggle firewall logging for VPC Firewalls. | `bool` | `true` | no |
| <a name="input_instance_image"></a> [instance_image](#input_instance_image) | The instance image. Must be debian base. | `string` | `"ubuntu-os-cloud/ubuntu-minimal-1804-lts"` | no |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type) | The instance type | `string` | `"e2-micro"` | no |
| <a name="input_max_replicas"></a> [max_replicas](#input_max_replicas) | The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas. | `number` | `1` | no |
| <a name="input_min_replicas"></a> [min_replicas](#input_min_replicas) | The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. | `number` | `1` | no |
| <a name="input_update_policy"></a> [update_policy](#input_update_policy) | The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager#rolling_update_policy | <pre>list(object({<br>    max_surge_fixed              = number<br>    instance_redistribution_type = string<br>    max_surge_percent            = number<br>    max_unavailable_fixed        = number<br>    max_unavailable_percent      = number<br>    min_ready_sec                = number<br>    replacement_method           = string<br>    minimal_action               = string<br>    type                         = string<br>  }))</pre> | <pre>[<br>  {<br>    "instance_redistribution_type": "NONE",<br>    "max_surge_fixed": 0,<br>    "max_surge_percent": null,<br>    "max_unavailable_fixed": 4,<br>    "max_unavailable_percent": null,<br>    "min_ready_sec": 180,<br>    "minimal_action": "RESTART",<br>    "replacement_method": "RECREATE",<br>    "type": "OPPORTUNISTIC"<br>  }<br>]</pre> | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_ilb_id"></a> [ilb_id](#output_ilb_id) | n/a |
<!-- END_TF_DOCS -->