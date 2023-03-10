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

resource "google_project_iam_member" "docker_gcr_rb" {
  project = var.project_name
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.docker_gcr_sa.email}"
}
