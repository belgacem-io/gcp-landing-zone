variable "project_id" {
  type = string
  description = "The project ID to host the cluster in"
}

variable "cluster_name" {
  type = string
  description = "the default cluster name"
}

variable "region" {
  type = string
  description = "The region to host the cluster in"
}
variable "region_azs" {
  description = "List of azs to host the cluster workers in"
  type = list(string)
}

variable "network_name" {
  type = string
  description = "The VPC network to host the cluster in"
}

variable "network_self_link" {
  type = string
  description = "The VPC network to host the cluster in"
}

variable "network_project_id" {
  type = string
  description = "The GCP project housing the VPC network to host the cluster in"
}

variable "subnetwork_name" {
  type = string
  description = "The subnetwork to host the cluster in"
}
variable "authorized_subnetwork_ip_ranges" {
  type = list(string)
  description = "The subnetwork ip range authorized to access master API"
}

variable "pods_secondary_ip_range_name" {
  type = string
  description = "The secondary ip range to use for pods"
}

variable "services_secondary_ip_range_name" {
  type = string
  description = "The secondary ip range to use for services"
}

variable "min_node_count" {
  type = number
  default = 1
  description = "Min node count"
}

variable "max_node_count" {
  type = number
  default = 3
  description = "Max nodes count"
}

variable "initial_node_count" {
  type = number
  default = 1
  description = "Initial node count"
}

variable "preemptible_nodes" {
  type = bool
  default = false
  description = "Use preemptible VMs as workers"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network"
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. The module enforces certain minimum versions to ensure that specific features are available. "
  default     = null
}

variable "release_channel" {
  type        = string
  description = "(Beta) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  default     = "STABLE"
}

variable "dns_zone" {
  type        = string
  description = "Google Cloud DNS Zone (e.g. google-cloud.example.com)"
}

variable "dns_zone_name" {
  type        = string
  description = "Google Cloud DNS Zone name (e.g. example-zone)"
}

variable "k8s_ingress_helm_chart_repo" {
  type        = string
  default     = "https://haproxytech.github.io/helm-charts"
  description = "HAPROXY ingress repository name."
}

variable "k8s_dashboard_namespace" {
  description = "Kubernetes Dashboard namespace."
  type = string
  default = "k8s-dashboard"
}

variable "nodes_tag" {
  description = "Network tags for GKE nodes."
  type = string
  default = "tf-lb-https-gke"
}

variable "ingress_service_port" {
  default = "30000"
}

variable "ingress_service_port_name" {
  default = "http"
}

variable "authorized_external_ip_ranges" {
  type        = list(string)
  description = "Authorized external ip ranges. Used mainly for the campany ranges filtering."
}
