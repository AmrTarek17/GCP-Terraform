resource "google_project_iam_member" "gke_rb" {
  project = var.project_name
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_management_rb" {
  project = var.project_name
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.gke_management_sa.email}"
}


# resource "google_project_iam_member" "registry_management_rb" {
#   project = var.project_name
#   role    = "roles/storage.admin"
#   member  = "serviceAccount:${google_service_account.gke_management_sa.email}"
# }



# resource "google_project_iam_member" "repo_admin_management_rb" {
#   project = var.project_name
#   role    = "roles/artifactregistry.repoAdmin"
#   member  = "serviceAccount:${google_service_account.gke_management_sa.email}"
# }
