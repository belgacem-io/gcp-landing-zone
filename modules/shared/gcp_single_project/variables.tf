variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "folder_id" {
  description = "The folder id where project will be created"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associated this project with"
  type        = string
  default = null
}

variable "activate_apis" {
  description = "The api to activate for the GCP project"
  type        = list(string)
  default     = []
}

variable "environment_code" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "vpc_service_control_attach_enabled" {
  description = "Whether the project will be attached to a VPC Service Control Perimeter"
  type        = bool
  default     = false
}

variable "vpc_service_control_perimeter_name" {
  description = "The name of a VPC Service Control Perimeter to add the created project to"
  type        = string
  default     = null
}

variable "alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded"
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}`"
  type        = string
  default     = null
}

variable "budget_amount" {
  description = "The amount to use as the budget"
  type        = number
  default     = 1000
}

variable "env_network_hub_project_id" {
  type = string
  description = "Environment hub network project id"
}

variable "env_network_hub_vpc_subnetwork_self_link" {
  type = any
}

variable "project_name" {
  type = string
  description = "project name"
}

variable "monitoring_project_id" {
  type = string
  description = "Monitoring project id"
}