module "orga_policies" {
  source        = "../gcp_orga_policies"
  resource_id   = var.parent_id
  resource_type = startswith("organization", var.parent_id) ? "organization" : "folder"

  domains_to_allow            = var.domains_to_allow
  skip_default_network_policy = true

}