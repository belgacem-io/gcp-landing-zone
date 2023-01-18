locals {
  mode                    = var.mode == null ? "" : var.mode == "hub" ? "-hub" : "-spoke"
  vpc_name                = "${var.environment_code}-shared${local.mode}"
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
}

/******************************************
  Base Network Hub
*****************************************/


data "google_compute_network" "org_network_hub_vpc" {
  count   = var.mode == "spoke" ? 1 : 0

  name    = var.org_network_hub_vpc_name
  project = var.org_network_hub_project_id
}

/******************************************
  Shared VPC configuration
 *****************************************/

module "main" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 5.2"

  project_id                             = var.project_id
  network_name                           = local.network_name
  shared_vpc_host                        = "true"
  delete_default_internet_gateway_routes = "true"

  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

  routes = concat(
    [{
      name              = "rt-${local.vpc_name}-1000-all-default-private-api"
      description       = "Route through IGW to allow private google api access."
      destination_range = "199.36.153.8/30"
      next_hop_internet = "true"
      priority          = "1000"
    }],
    var.nat_enabled ?
    [
      {
        name              = "rt-${local.vpc_name}-1000-egress-internet-default"
        description       = "Tag based route through IGW to access internet"
        destination_range = "0.0.0.0/0"
        tags              = "egress-internet"
        next_hop_internet = "true"
        priority          = "1000"
      }
    ]
    : [],
    var.windows_activation_enabled ?
    [{
      name              = "rt-${local.vpc_name}-1000-all-default-windows-kms"
      description       = "Route through IGW to allow Windows KMS activation for GCP."
      destination_range = "35.190.247.13/32"
      next_hop_internet = "true"
      priority          = "1000"
      }
    ]
    : []
  )
}


/************************************
  Router to advertise shared VPC
  subnetworks and Google Private API
************************************/

module "region1_router1" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 4.0"

  count   = var.mode != "spoke" ? 1 : 0

  name    = "cr-${local.vpc_name}-${var.default_region1}-cr1"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region1
  bgp = {
    asn                  = var.bgp_asn_subnet
    advertised_groups    = ["ALL_SUBNETS"]
    advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
  }
}

module "region1_router2" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 4.0"

  count   = var.mode != "spoke" ? 1 : 0

  name    = "cr-${local.vpc_name}-${var.default_region1}-cr2"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region1
  bgp = {
    asn                  = var.bgp_asn_subnet
    advertised_groups    = ["ALL_SUBNETS"]
    advertised_ip_ranges = [{ range = local.private_googleapis_cidr }]
  }
}