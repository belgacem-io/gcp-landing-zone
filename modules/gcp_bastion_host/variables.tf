variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization."
}
variable "prefix" {
  type        = string
  description = "Prefix applied to service to all resources."
}

variable "authorized_members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = list(string)
}

variable "project_id" {
  type        = string
  description = "Project ID where to set up the instance and IAP tunneling"
}

variable "instance_name" {
  type        = string
  description = "Name of the VM instance to create and allow SSH from IAP."
}

variable "instance_type" {
  type        = string
  description = "Type of the VM instance to create and allow SSH from IAP."
  default     = "e2-micro" #"n1-standard-1"
}

variable "region" {
  type        = string
  description = "Region to create the subnet and VM."
}

variable "network_self_link" {
  type        = string
  description = "Network where to install the bastion host"
}

variable "subnet_self_link" {
  type        = string
  description = "Subnet where to install the bastion host"
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
