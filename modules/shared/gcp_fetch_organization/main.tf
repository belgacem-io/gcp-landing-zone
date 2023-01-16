/******************************************
  Projects
*****************************************/
data "google_projects" "all" {

  filter = "lifecycleState=ACTIVE"
}

data "google_project" "projects" {
  for_each = toset(data.google_projects.all.projects.*.project_id)

  project_id = each.value
}

/******************************************
  Folders
*****************************************/

data "google_folders" "level1" {
  parent_id = "organizations/${var.organization_id}"
}

data "google_folders" "level2" {
  for_each  = toset(data.google_folders.level1.folders.*.name)
  parent_id = each.value
}


locals {
  folders          = concat(data.google_folders.level1.folders, flatten(values(data.google_folders.level2).*.folders))
  folders_by_env_code      = { for parent in data.google_folders.level1.folders:
        replace(lower(parent.display_name),"_environment","") => {
              for folder in data.google_folders.level2[parent.name].folders: folder.display_name => folder
        }

  }
  projects_by_name = {for k, v in data.google_project.projects : v.name => v}
  network_hubs_by_env_code = {for k, v in data.google_project.projects :
        v.labels.environment_code => v if can(v.labels["environment_code"])
                                        && can(v.labels["application_name"])
                                        && try(v.labels.application_name, "") == "network-hub"
  }

  network_hubs_subnets_by_env_code = {for k, v in data.google_compute_network.network_hub_vpc :
        k => [for subnet in v.subnetworks_self_links: data.google_compute_subnetwork.network_hub_subnetwork[subnet] ]
  }

  //Subnet descriptions are structure : {environment code} / {project name} / { region }
  shared_subnets_regions  = distinct( [ for description in values(data.google_compute_subnetwork.network_hub_subnetwork).*.description: split("/",description)[2]] )
  shared_subnets_peered_projects = distinct( [ for description in values(data.google_compute_subnetwork.network_hub_subnetwork).*.description:
        {
          environment_code = split("/",description)[0]
          project_name = split("/",description)[1]
        }
  ] )
  shared_subnets_by_project_and_region = { for prj in local.shared_subnets_peered_projects:
      "${prj.environment_code}-${prj.project_name}" => {
            for region in local.shared_subnets_regions:
                  region => [ for subnet in data.google_compute_subnetwork.network_hub_subnetwork :
                            subnet if split("/",subnet.description)[0]  == prj.environment_code
                            && split("/",subnet.description)[1]  == prj.project_name
                            && split("/",subnet.description)[2]  == region
                  ]
        }
  }
}
/******************************************
  Network
*****************************************/

data "google_compute_network" "network_hub_vpc" {
  for_each = local.network_hubs_by_env_code

  name    = "vpc-${each.key}-shared-spoke"
  project = each.value.project_id

  depends_on = [
    data.google_project.projects
  ]
}

data "google_compute_subnetwork" "network_hub_subnetwork" {
  for_each = toset(flatten(values(data.google_compute_network.network_hub_vpc).*.subnetworks_self_links))

  self_link = each.value
}
