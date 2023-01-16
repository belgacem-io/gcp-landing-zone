output "organization_iam_groups_bindings" {
  value = local.organization_iam_groups_bindings
}

output "folder_iam_groups_bindings" {
  value = local.folder_iam_groups_bindings
}

output "project_iam_groups_bindings" {
  value = local.project_iam_groups_bindings
}

output "projects" {
  value = data.google_projects.all.projects
}


output "folders" {
  value = local.folders
}