/******************************************
 DNS Public
*****************************************/

module "dns-public-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.0"

  project_id = local.org_network_hub_project_id
  type       = "public"
  name       = "fz-dns-hub"
  domain     = "${var.domain}."

}