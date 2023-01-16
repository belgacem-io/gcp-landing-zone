resource "google_service_account" "vm_sa" {
  project      = var.project_id
  account_id   = var.instance_name
  display_name = "Service Account for Bastion host"
}

# A testing VM to allow OS Login + IAP tunneling.
module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 7.3"

  project_id      = var.project_id
  machine_type    = "n1-standard-1"
  subnetwork      = var.subnet_self_link
  service_account = {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
  metadata        = {
    enable-oslogin = "TRUE"
  }
}

resource "google_compute_instance_from_template" "vm" {
  name                     = var.instance_name
  project                  = var.project_id
  zone                     = var.zone
  network_interface {
    subnetwork = var.subnet_self_link
  }
  source_instance_template = module.instance_template.self_link
}

# Additional OS login IAM bindings.
# https://cloud.google.com/compute/docs/instances/managing-instance-access#granting_os_login_iam_roles
resource "google_service_account_iam_binding" "sa_user" {
  service_account_id = google_service_account.vm_sa.id
  role               = "roles/iam.serviceAccountUser"
  members            = var.members
}

resource "google_project_iam_member" "os_login_bindings" {
  for_each = toset(var.members)
  project  = var.project_id
  role     = "roles/compute.osLogin"
  member   = each.key
}

module "iap_tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "~> 4.1"

  fw_name_allow_ssh_from_iap = "test-allow-ssh-from-iap-to-tunnel"
  project                    = var.project_id
  host_project               = var.host_project
  network                    = var.network_self_link
  service_accounts           = [google_service_account.vm_sa.email]
  instances                  = [
    {
      name = google_compute_instance_from_template.vm.name
      zone = var.zone
    }
  ]
  members                    = var.members
}