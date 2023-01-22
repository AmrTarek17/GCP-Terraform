provider "google" {
  project = "eminent-subset-375011"
  region = "asia-east1"
  credentials = file(var.credentials_file_path)
}

