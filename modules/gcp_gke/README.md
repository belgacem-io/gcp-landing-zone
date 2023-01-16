<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 3.77 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module_gke) | terraform-google-modules/kubernetes-engine/google//modules/private-cluster | ~> 19.0 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_external_ip_ranges"></a> [authorized_external_ip_ranges](#input_authorized_external_ip_ranges) | Authorized external ip ranges. Used mainly for the campany ranges filtering. | `list(string)` | n/a | yes |
| <a name="input_authorized_subnetwork_ip_ranges"></a> [authorized_subnetwork_ip_ranges](#input_authorized_subnetwork_ip_ranges) | The subnetwork ip range authorized to access master API | `list(string)` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name) | the default cluster name | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns_zone](#input_dns_zone) | Google Cloud DNS Zone (e.g. google-cloud.example.com) | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns_zone_name](#input_dns_zone_name) | Google Cloud DNS Zone name (e.g. example-zone) | `string` | n/a | yes |
| <a name="input_master_ipv4_cidr_block"></a> [master_ipv4_cidr_block](#input_master_ipv4_cidr_block) | The IP range in CIDR notation to use for the hosted master network | `string` | n/a | yes |
| <a name="input_network_name"></a> [network_name](#input_network_name) | The VPC network to host the cluster in | `string` | n/a | yes |
| <a name="input_network_project_id"></a> [network_project_id](#input_network_project_id) | The GCP project housing the VPC network to host the cluster in | `string` | n/a | yes |
| <a name="input_network_self_link"></a> [network_self_link](#input_network_self_link) | The VPC network to host the cluster in | `string` | n/a | yes |
| <a name="input_pods_secondary_ip_range_name"></a> [pods_secondary_ip_range_name](#input_pods_secondary_ip_range_name) | The secondary ip range to use for pods | `string` | n/a | yes |
| <a name="input_project_id"></a> [project_id](#input_project_id) | The project ID to host the cluster in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input_region) | The region to host the cluster in | `string` | n/a | yes |
| <a name="input_region_azs"></a> [region_azs](#input_region_azs) | List of azs to host the cluster workers in | `list(string)` | n/a | yes |
| <a name="input_services_secondary_ip_range_name"></a> [services_secondary_ip_range_name](#input_services_secondary_ip_range_name) | The secondary ip range to use for services | `string` | n/a | yes |
| <a name="input_subnetwork_name"></a> [subnetwork_name](#input_subnetwork_name) | The subnetwork to host the cluster in | `string` | n/a | yes |
| <a name="input_ingress_service_port"></a> [ingress_service_port](#input_ingress_service_port) | n/a | `string` | `"30000"` | no |
| <a name="input_ingress_service_port_name"></a> [ingress_service_port_name](#input_ingress_service_port_name) | n/a | `string` | `"http"` | no |
| <a name="input_initial_node_count"></a> [initial_node_count](#input_initial_node_count) | Initial node count | `number` | `1` | no |
| <a name="input_k8s_dashboard_namespace"></a> [k8s_dashboard_namespace](#input_k8s_dashboard_namespace) | Kubernetes Dashboard namespace. | `string` | `"eclair-dashboard"` | no |
| <a name="input_k8s_ingress_helm_chart_repo"></a> [k8s_ingress_helm_chart_repo](#input_k8s_ingress_helm_chart_repo) | HAPROXY ingress repository name. | `string` | `"https://haproxytech.github.io/helm-charts"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes_version](#input_kubernetes_version) | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. The module enforces certain minimum versions to ensure that specific features are available. | `string` | `null` | no |
| <a name="input_max_node_count"></a> [max_node_count](#input_max_node_count) | Max nodes count | `number` | `3` | no |
| <a name="input_min_node_count"></a> [min_node_count](#input_min_node_count) | Min node count | `number` | `1` | no |
| <a name="input_nodes_tag"></a> [nodes_tag](#input_nodes_tag) | Network tags for GKE nodes. | `string` | `"tf-lb-https-gke"` | no |
| <a name="input_preemptible_nodes"></a> [preemptible_nodes](#input_preemptible_nodes) | Use preemptible VMs as workers | `bool` | `false` | no |
| <a name="input_release_channel"></a> [release_channel](#input_release_channel) | (Beta) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`. | `string` | `"STABLE"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke"></a> [gke](#output_gke) | n/a |
<!-- END_TF_DOCS -->