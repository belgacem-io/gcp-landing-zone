variable "parent_container_id" {
  type        = string
  description = "Can be either an organisation or a folder. Format : organizations/1235 or folders/12562."
}

variable "organization_name" {
  description = "The organization name, will be used for resources naming."
  type        = string
}

variable "default_region" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}
