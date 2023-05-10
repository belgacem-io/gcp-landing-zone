resource "google_service_account" "vm_sa" {
  project      = var.project_id
  account_id   = var.instance_name
  display_name = "Service Account for Bastion host"
}

# A bastion VM template to allow OS Login + IAP tunneling.
module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 7.9"

  name_prefix     = "${var.environment_code}-${var.instance_name}"
  project_id      = var.project_id
  machine_type    = var.instance_type
  subnetwork      = var.subnet_self_link
  service_account = {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 7.9"

  project_id        = var.project_id
  region            = var.region
  #[prefix]-[resource]-[location]-[description]-[suffix]
  hostname          = "${var.prefix}-mig-${var.instance_name}"
  instance_template = module.instance_template.self_link

  /* autoscaler */
  autoscaling_enabled          = var.autoscaling_enabled
  max_replicas                 = var.max_replicas
  min_replicas                 = var.min_replicas
  cooldown_period              = var.cooldown_period
  autoscaling_cpu              = var.autoscaling_cpu
  autoscaling_metric           = var.autoscaling_metric
  autoscaling_lb               = var.autoscaling_lb
  autoscaling_scale_in_control = var.autoscaling_scale_in_control

  depends_on = [
    module.instance_template
  ]
}


# Additional OS login IAM bindings.
# https://cloud.google.com/compute/docs/instances/managing-instance-access#granting_os_login_iam_roles
resource "google_service_account_iam_binding" "sa_user" {
  service_account_id = google_service_account.vm_sa.id
  role               = "roles/iam.serviceAccountUser"
  members            = var.authorized_members
}

resource "google_project_iam_member" "os_login_bindings" {
  for_each = toset(var.authorized_members)
  project  = var.project_id
  role     = "roles/compute.osLogin"
  member   = each.key
}

module "iap_tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "~> 5.1"

  fw_name_allow_ssh_from_iap = "allow-ssh-from-iap-to-tunnel"
  project                    = var.project_id
  network                    = var.network_self_link
  service_accounts           = [google_service_account.vm_sa.email]
  instances                  = []
  members                    = var.authorized_members
}