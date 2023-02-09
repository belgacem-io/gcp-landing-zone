<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_external_ip_ranges"></a> [authorized\_external\_ip\_ranges](#input\_authorized\_external\_ip\_ranges) | Authorized external ip ranges. Used mainly for the campany ranges filtering. | `list(string)` | n/a | yes |
| <a name="input_authorized_subnetwork_ip_ranges"></a> [authorized\_subnetwork\_ip\_ranges](#input\_authorized\_subnetwork\_ip\_ranges) | The subnetwork ip range authorized to access master API | `list(string)` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | the default cluster name | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | Google Cloud DNS Zone (e.g. google-cloud.example.com) | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | Google Cloud DNS Zone name (e.g. example-zone) | `string` | n/a | yes |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The IP range in CIDR notation to use for the hosted master network | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The VPC network to host the cluster in | `string` | n/a | yes |
| <a name="input_network_project_id"></a> [network\_project\_id](#input\_network\_project\_id) | The GCP project housing the VPC network to host the cluster in | `string` | n/a | yes |
| <a name="input_network_self_link"></a> [network\_self\_link](#input\_network\_self\_link) | The VPC network to host the cluster in | `string` | n/a | yes |
| <a name="input_pods_secondary_ip_range_name"></a> [pods\_secondary\_ip\_range\_name](#input\_pods\_secondary\_ip\_range\_name) | The secondary ip range to use for pods | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the cluster in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to host the cluster in | `string` | n/a | yes |
| <a name="input_region_azs"></a> [region\_azs](#input\_region\_azs) | List of azs to host the cluster workers in | `list(string)` | n/a | yes |
| <a name="input_services_secondary_ip_range_name"></a> [services\_secondary\_ip\_range\_name](#input\_services\_secondary\_ip\_range\_name) | The secondary ip range to use for services | `string` | n/a | yes |
| <a name="input_subnetwork_name"></a> [subnetwork\_name](#input\_subnetwork\_name) | The subnetwork to host the cluster in | `string` | n/a | yes |
| <a name="input_ingress_service_port"></a> [ingress\_service\_port](#input\_ingress\_service\_port) | n/a | `string` | `"30000"` | no |
| <a name="input_ingress_service_port_name"></a> [ingress\_service\_port\_name](#input\_ingress\_service\_port\_name) | n/a | `string` | `"http"` | no |
| <a name="input_initial_node_count"></a> [initial\_node\_count](#input\_initial\_node\_count) | Initial node count | `number` | `1` | no |
| <a name="input_k8s_dashboard_namespace"></a> [k8s\_dashboard\_namespace](#input\_k8s\_dashboard\_namespace) | Kubernetes Dashboard namespace. | `string` | `"k8s-dashboard"` | no |
| <a name="input_k8s_ingress_helm_chart_repo"></a> [k8s\_ingress\_helm\_chart\_repo](#input\_k8s\_ingress\_helm\_chart\_repo) | HAPROXY ingress repository name. | `string` | `"https://haproxytech.github.io/helm-charts"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. The module enforces certain minimum versions to ensure that specific features are available. | `string` | `null` | no |
| <a name="input_max_node_count"></a> [max\_node\_count](#input\_max\_node\_count) | Max nodes count | `number` | `3` | no |
| <a name="input_min_node_count"></a> [min\_node\_count](#input\_min\_node\_count) | Min node count | `number` | `1` | no |
| <a name="input_nodes_tag"></a> [nodes\_tag](#input\_nodes\_tag) | Network tags for GKE nodes. | `string` | `"tf-lb-https-gke"` | no |
| <a name="input_preemptible_nodes"></a> [preemptible\_nodes](#input\_preemptible\_nodes) | Use preemptible VMs as workers | `bool` | `false` | no |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | (Beta) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`. | `string` | `"STABLE"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke"></a> [gke](#output\_gke) | n/a |
<!-- END_TF_DOCS -->