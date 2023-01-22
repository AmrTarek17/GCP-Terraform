provider "google" {
  project = "eminent-subset-375011"
  region = "europe-west1"
  credentials = file(var.credentials_file_path)
}

