variable "project_id" {
  description = "The project id of your GCP project"
  type        = string
}

variable "default_region1" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}

variable "vpc_name" {
  description = "The GCP VPC network name for the cluster to be built in."
  type        = string
}

variable "subnet_name" {
  description = "The subnet in the VPC for the proxy cluster to be deployed to."
  type        = string
}

variable "service_root_name" {
  description = "Root name that all cloud objects will be named with."
  type        = string
}

variable "environment_code" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "internal_trusted_cidr_ranges" {
  description = "Your internal CIDR range requiring access to this proxy."
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

variable "network_internet_egress_tag" {
  type        = string
  description = "Network tags for VMs with internet access."
}
variable "authorized_ports" {
  type        = list(string)
  description = "List of safe ports."
  default     = [
    "80", # http
    "443", # https
    "21", # ftp
    "3128" # Default proxy port
  ]
}

