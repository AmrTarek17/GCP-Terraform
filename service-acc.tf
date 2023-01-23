resource "google_service_account" "gke_sa" {
  account_id   = "gke-sa"
  display_name = "GKE Service Account"
  
}

resource "google_service_account" "gke_management_sa" {
  account_id   = "gke-management-sa"
  display_name = "GKE Management Service Account"
  
}