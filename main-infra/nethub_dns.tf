/******************************************
 DNS Public
*****************************************/

module "dns-public-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.2"

  project_id = module.nethub_project.project_id
  type       = "public"
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name       = "${var.gcp_organization_name}-prod-fz-glob"
  domain     = "${var.gcp_organization_domain}."

  depends_on = [
    module.nethub_project
  ]

}