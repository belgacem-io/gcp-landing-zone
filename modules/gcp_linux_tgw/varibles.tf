variable "project_id" {
  description = "The project id of your GCP project"
  type        = string
}

variable "prefix" {
  type        = string
  description = "Prefix applied to service to all resources."
}

variable "default_region" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}

variable "network_name" {
  description = "The GCP VPC network name for the cluster to be built in."
  type        = string
}

variable "subnetwork_name" {
  description = "The subnet in the VPC for the proxy cluster to be deployed to."
  type        = string
}

variable "environment_code" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "source_trusted_cidr_ranges" {
  description = "Your internal CIDR range requiring access to this proxy."
  type        = list(string)
}

variable "destination_trusted_cidr_ranges" {
  description = "Your internal/external CIDR range requiring access from this proxy."
  type        = list(string)
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "e2-micro"
}

variable "instance_image" {
  description = "The instance image. Must be debian base."
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
}

variable "max_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas."
  default     = 1
}

variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0."
  default     = 1
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  default     = 60
}

variable "autoscaling_cpu" {
  description = "Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization"
  type        = list(map(number))
  default     = []
}

variable "autoscaling_metric" {
  description = "Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric"
  type        = list(object({
    name   = string
    target = number
    type   = string
  }))
  default = []
}

variable "autoscaling_lb" {
  description = "Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization"
  type        = list(map(number))
  default     = []
}

variable "autoscaling_scale_in_control" {
  description = "Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control"
  type        = object({
    fixed_replicas   = number
    percent_replicas = number
    time_window_sec  = number
  })
  default = {
    fixed_replicas   = 0
    percent_replicas = 30
    time_window_sec  = 600
  }
}

variable "autoscaling_enabled" {
  description = "Creates an autoscaler for the managed instance group"
  type        = bool
  default     = false
}

variable "network_tags" {
  type        = list(string)
  description = "Network tags for VMs."
  default = []
}

variable "update_policy" {
  type = list(object({
    max_surge_fixed              = number
    instance_redistribution_type = string
    max_surge_percent            = number
    max_unavailable_fixed        = number
    max_unavailable_percent      = number
    min_ready_sec                = number
    replacement_method           = string
    minimal_action               = string
    type                         = string
  }))
  description = "The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager#rolling_update_policy"
  default     = [
    {
      max_surge_fixed              = 0
      max_surge_percent            = null
      instance_redistribution_type = "NONE"
      max_unavailable_fixed        = 4
      max_unavailable_percent      = null
      min_ready_sec                = 180
      minimal_action               = "RESTART"
      type                         = "OPPORTUNISTIC"
      replacement_method           = "RECREATE"
    }
  ]
}
variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}

variable "authorized_members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = list(string)
  default = []
}