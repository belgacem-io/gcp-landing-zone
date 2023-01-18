locals {
  db_name = "pg-11"
}
module "pg" {
  source               = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name                 = local.db_name
  random_instance_name = true
  project_id           = module.fetch.projects_by_name["exp-uc1-kube"].project_id
  database_version     = "POSTGRES_11"
  region               = var.gcp_default_region1

  // Master configurations
  tier                            = "db-custom-2-13312"
  zone                            = var.gcp_default_region1_azs[0]
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  deletion_protection = false

  database_flags = [{ name = "autovacuum", value = "off" }]

  user_labels = {
    foo = "bar"
  }

  ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = false
    private_network = module.fetch.nethubs_shared_vpc_by_env_code["exp"].self_link
    authorized_networks = []
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  db_name      = local.db_name
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  user_name     = "tftest"
  user_password = "foobar"
}