locals {

  folders = concat(data.google_folders.level1.folders, flatten(values(data.google_folders.level2).*.folders))

  organization_iam_groups_roles = flatten([
    for key,group in var.organization_iam_groups: [
        for role in group.roles: {
            role          =  role
            group         =  group.name
            group_email   =  group.email
        }
    ]
  ])

  organization_iam_groups_bindings = {
      for role in distinct(local.organization_iam_groups_roles.*.role) : role => [
          for item in local.organization_iam_groups_roles : "group:${item.group_email}" if role == item.role
      ]
  }

  folder_iam_groups_roles = flatten([
    for key,group in var.folder_iam_groups: [
          for folder in group.folders: [
            for role in group.roles: {
              role          =  role
              group         =  group.name
              group_email   =  group.email
              folder        =  folder
            }
        ]
    ]
  ])
  folder_iam_groups_bindings = {
      for folder in distinct(local.folder_iam_groups_roles.*.folder) : replace(local.folders[index(local.folders.*.display_name,folder)].name,"folders/","") => {
        for role in distinct(local.folder_iam_groups_roles.*.role) : role => [
            for item in local.folder_iam_groups_roles : "group:${item.group_email}" if role == item.role && item.folder == folder
        ]
      }
  }

  project_iam_groups_roles = flatten([
    for key,group in var.project_iam_groups: [
          for project in group.projects: [
            for role in group.roles: {
              role          =  role
              group         =  group.name
              group_email   =  group.email
              project       =  project
            }
        ]
    ]
  ])
  project_iam_groups_bindings = {
      for project in distinct(local.project_iam_groups_roles.*.project) : data.google_projects.all.projects[index(data.google_projects.all.projects.*.name,project)].project_id => {
        for role in distinct(local.project_iam_groups_roles.*.role) : role => [
            for item in local.project_iam_groups_roles : "group:${item.group_email}" if role == item.role && item.project == project
        ]
      }
  }

}
data "google_projects" "all" {
  filter = "lifecycleState:ACTIVE"
}

data "google_folders" "level1" {
  parent_id = "organizations/${var.organization_id}"
}

data "google_folders" "level2" {
  for_each = toset(data.google_folders.level1.folders.*.name)
  parent_id = each.value
}
