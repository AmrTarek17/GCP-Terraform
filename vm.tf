resource "google_compute_instance" "private-vm" {
  name         = "private-vm"
  machine_type = "e2-micro"
  zone         = "${module.network.out_sub2_region}-d"
  allow_stopping_for_update = true
  service_account {
    email = google_service_account.gke_management_sa.email
    scopes = [ "cloud-platform" ]
  }
  depends_on = [
    module.network,
    google_compute_firewall.allow_ssh
  ]
 
  metadata_startup_script = <<-EOF
    sudo apt-get install  -y apt-transport-https ca-certificates gnupg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update && sudo apt-get install google-cloud -y   
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl
    kubectl version --client
    sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
  EOF



  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      type = "pd-standard"
      size = 10
    }
  }


  network_interface {
    network = module.network.out_vpc_name
    subnetwork = module.network.out_sub2_name
  }
}