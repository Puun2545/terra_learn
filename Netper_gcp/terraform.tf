# Configure Terraform provider for Google Cloud Platform
provider "google" {
  project = "netper1"
  region  = "asia-southeast1"
}

# Create a VPC network for your resources
resource "google_compute_network" "default" {
  name = "my-vpc-network"
}

# Create a subnet for your VMs
resource "google_compute_subnetwork" "default" {
  name          = "my-vpc-subnet"
  ip_cidr_range = "10.1.0.0/16"
  network       = google_compute_network.default.name
}

# Create a firewall rule to allow HTTP traffic to the web server
resource "google_compute_firewall" "webserver-allow-http" {
  name       = "allow-http-webserver"
  network    = google_compute_network.default.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Web server VM configuration
resource "google_compute_instance" "webserver" {
  name         = "webserver-vm"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-a"  # Specify the zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os/cloud/ubuntu-22.04-lts" 
    }
  }

  network_interface {
    network = google_compute_network.default.name
    subnetwork = google_compute_subnetwork.default.name
    access_config {
      nat_ip = google_compute_address.webserver_ip.address  # Attach static IP (optional)
    }
  }
}

# Load balancer VM configuration (change image for load testing tool)
resource "google_compute_instance" "loadbalancer" {
  name         = "loadbalancer-vm"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-b"  # Specify the zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os/cloud/ubuntu-22.04-lts"  # Replace with your load testing tool image
    }
  }

  network_interface {
    network = google_compute_network.default.name
    subnetwork = google_compute_subnetwork.default.name
    access_config {
      nat_ip = google_compute_address.loadbalancer_ip.address  # Attach static IP (optional)
    }
  }
}

# Assign external IP addresses to the VMs (optional)
resource "google_compute_address" "webserver_ip" {
  name = "webserver-ip"
}

resource "google_compute_address" "loadbalancer_ip" {
  name = "loadbalancer-ip"
}

# Remove redundant resources (not needed with network_interface block)
# resource "google_compute_instance_attachment" "webserver_attach_ip" {}
# resource "google_compute_instance_attachment" "loadbalancer_attach_ip" {}
