resource "google_compute_instance" "terraform-instance" {
  name = "terraform-vm"
  machine_type = "e2-micro"
  network_interface {
    network = "default"
  }
  boot_disk {
    initialize_params {
      image = "custom-img-nginx"
    }
  }

}