locals {
  private_googleapis_cidr = "199.36.153.8/30"
  public_subnets          = [
    for subnet in var.public_subnets : {
      #[prefix]-[resource]-[location]-[description]-[suffix]
      subnet_name           = "${var.prefix}-subnet-${var.default_region}-${subnet.subnet_name}-${index(var.public_subnets, subnet.subnet_name)}"
      subnet_ip             = subnet.subnet_ip
      subnet_region         = var.default_region
      subnet_private_access = false
      subnet_flow_logs      = var.subnetworks_enable_logging
      purpose               = "PRIVATE"
    }
  ]
  private_subnets = [
    for subnet in var.private_subnets : {
      #[prefix]-[resource]-[location]-[description]-[suffix]
      subnet_name           = "${var.prefix}-subnet-${var.default_region}-${subnet.subnet_name}-${index(var.private_subnets, subnet.subnet_name)}"
      subnet_ip             = subnet.subnet_ip
      subnet_region         = var.default_region
      subnet_private_access = true
      subnet_flow_logs      = var.subnetworks_enable_logging
      purpose               = "PRIVATE"
    }
  ]
  data_subnets = [
    for subnet in var.data_subnets : {
      #[prefix]-[resource]-[location]-[description]-[suffix]
      subnet_name           = "${var.prefix}-subnet-${var.default_region}-${subnet.subnet_name}-${index(var.data_subnets, subnet.subnet_name)}"
      subnet_ip             = subnet.subnet_ip
      subnet_region         = var.default_region
      subnet_private_access = true
      subnet_flow_logs      = var.subnetworks_enable_logging
      purpose               = "PRIVATE"
    }
  ]

  private_svc_connect_subnets = [
    for subnet in var.private_svc_connect_subnets : {
      #[prefix]-[resource]-[location]-[description]-[suffix]
      subnet_name           = "${var.prefix}-subnet-${var.default_region}-${subnet.subnet_name}-${index(var.private_svc_connect_subnets, subnet.subnet_name)}"
      subnet_ip             = subnet.subnet_ip
      subnet_region         = var.default_region
      subnet_private_access = true
      subnet_flow_logs      = var.subnetworks_enable_logging
      purpose               = "PRIVATE_SERVICE_CONNECT"
    }
  ]

  subnets = concat(local.public_subnets, local.private_subnets, local.data_subnets, local.private_svc_connect_subnets)
}


/******************************************
  Shared VPC configuration
 *****************************************/

module "main" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.2"

  project_id                             = var.project_id
  #[prefix]-[resource]-[location]-[description]-[suffix]
  network_name                           = "${var.prefix}-network-${var.default_region}-${var.network_name}"
  shared_vpc_host                        = var.shared_vpc_host
  delete_default_internet_gateway_routes = true

  subnets          = local.subnets
  secondary_ranges = var.secondary_ranges

  routes = concat(
    var.nat_enabled ? [
      {
        #[prefix]-[resource]-[location]-[description]-[suffix]
        name              = "${var.prefix}-rt-glb-1000-all-default-private-api"
        description       = "Route through IGW to allow private google api access."
        destination_range = "199.36.153.8/30"
        next_hop_internet = "true"
        priority          = "1000"
      }
    ] : [],
    var.nat_enabled && var.windows_activation_enabled ?
    [
      {
        #[prefix]-[resource]-[location]-[description]-[suffix]
        name              = "${var.prefix}-rt-glb-1000-all-default-windows-kms"
        description       = "Route through IGW to allow Windows KMS activation for GCP."
        destination_range = "35.190.247.13/32"
        next_hop_internet = "true"
        priority          = "1000"
      }
    ]
    : []
  )
}