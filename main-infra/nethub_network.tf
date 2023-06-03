/******************************************
  DMZ Network
*****************************************/

module "nethub_network_dmz" {
  source = "../modules/gcp_network"

  project_id                    = module.nethub_project.project_id
  environment_code              = "prod"
  prefix                        = "${var.gcp_org_name}-prod"
  default_region                = var.gcp_default_region
  public_domain                 = var.gcp_org_public_domain
  private_domain                = var.gcp_org_private_domain
  enable_nat                    = true
  enable_dns_inbound_forwarding = false
  enable_secure_web_proxy       = true
  enable_public_domain          = false
  enable_private_domain         = false
  enable_transitive_network     = false
  network_name                  = var.gcp_infra_projects.nethub.networks.dmz.name
  mode                          = "hub"

  public_subnets = [
    for range in var.gcp_infra_projects.nethub.networks.dmz.cidr_blocks.public_subnet_ranges : {
      subnet_suffix = "dmz-public", subnet_range = range
    }
  ]
  private_subnets = [
    for range in var.gcp_infra_projects.nethub.networks.dmz.cidr_blocks.private_subnet_ranges :{
      subnet_suffix = "dmz-private", subnet_range = range
    }
  ]
  data_subnets = [
    for range in var.gcp_infra_projects.nethub.networks.dmz.cidr_blocks.data_subnet_ranges : {
      subnet_suffix = "dmz-data", subnet_range = range
    }
  ]

  secondary_ranges = {}

  allow_egress_ranges          = var.trusted_egress_ranges
  allow_ingress_ranges         = var.trusted_ingress_ranges
  internal_trusted_cidr_ranges = var.trusted_private_ranges

  depends_on = [
    module.nethub_project
  ]
}

/******************************************
  Corp Network.
 *****************************************/

module "nethub_network_corp" {
  source = "../modules/gcp_network"

  project_id                    = module.nethub_project.project_id
  environment_code              = "prod"
  prefix                        = "${var.gcp_org_name}-prod"
  default_region                = var.gcp_default_region
  public_domain                 = var.gcp_org_public_domain
  private_domain                = var.gcp_org_private_domain
  enable_nat                    = false
  enable_dns_inbound_forwarding = true
  enable_secure_web_proxy       = false
  enable_public_domain          = false
  enable_private_domain         = true
  enable_transitive_network     = true
  network_name                  = var.gcp_infra_projects.nethub.networks.corp.name
  mode                          = "hub"

  public_subnets = []
  private_subnets = [
    for range in var.gcp_infra_projects.nethub.networks.corp.cidr_blocks.private_subnet_ranges :{
      subnet_suffix = "corp-private",
      subnet_range = range
    }
  ]
  data_subnets = [
    for range in var.gcp_infra_projects.nethub.networks.corp.cidr_blocks.data_subnet_ranges : {
      subnet_suffix = "corp-data",
      subnet_range = range
    }
  ]
  private_svc_connect_ip = var.gcp_infra_projects.nethub.networks.corp.cidr_blocks.private_svc_connect_ip

  secondary_ranges = {}

  allow_egress_ranges          = []
  allow_ingress_ranges         = var.trusted_ingress_ranges
  internal_trusted_cidr_ranges = var.trusted_private_ranges

  depends_on = [
    module.nethub_project
  ]
}

/******************************************
  Secure web proxy DNS record.
 *****************************************/

resource "google_dns_record_set" "secure_web_proxy" {
  name = "proxy.${var.gcp_org_private_domain}."
  project    = module.nethub_project.project_id
  type = "A"
  ttl  = 300

  managed_zone = module.nethub_network_corp.private_zone_name

  rrdatas = [module.nethub_network_dmz.secure_web_proxy_ip_address]

  depends_on = [
      module.nethub_network_corp,
      module.nethub_network_dmz
  ]
}