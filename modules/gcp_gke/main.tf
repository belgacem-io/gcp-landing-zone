data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 24.0"

  project_id                        = var.project_id
  name                              = var.cluster_name
  region                            = var.region
  network                           = var.network_name
  network_project_id                = var.network_project_id
  subnetwork                        = var.subnetwork_name
  ip_range_pods                     = var.pods_secondary_ip_range_name
  ip_range_services                 = var.services_secondary_ip_range_name
  http_load_balancing               = true
  enable_private_endpoint           = true
  enable_private_nodes              = true
  master_ipv4_cidr_block            = var.master_ipv4_cidr_block
  create_service_account            = true
  network_policy                    = true
  horizontal_pod_autoscaling        = true
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true
  release_channel                   = var.release_channel
  kubernetes_version                = var.kubernetes_version

  master_authorized_networks = [
    for range in var.authorized_subnetwork_ip_ranges :
    {
      cidr_block   = range
      display_name = "VPC"
    }
  ]

  node_pools = [
    {
      name               = "my-node-pool"
      machine_type       = "n1-standard-1"
      min_count          = var.min_node_count
      max_count          = var.max_node_count
      disk_size_gb       = 100
      disk_type          = "pd-ssd"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = var.initial_node_count
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/logging.write"
    ]
    my-node-pool = [
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }

  node_pools_labels = {

    all = {

    }
    my-node-pool = {

    }
  }

  node_pools_metadata = {
    all = {}

    my-node-pool = {}

  }

  node_pools_tags = {
    all = []

    my-node-pool = [var.nodes_tag]

  }
}