locals {
  data_device = "/dev/sdb"
}

resource "google_compute_address" "static" {
  name         = "gcenode"
  address_type = "EXTERNAL"
}

resource "google_compute_instance" "gce_node" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.zone

  metadata = {
    ssh-keys = join("\n", [for user, key in var.ssh_keys : "${user}:ssh-rsa ${key} ${user}"])
    name     = "ndoh-gce_node"
  }

  lifecycle {
    ignore_changes = [metadata_startup_script]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  attached_disk {
    device_name = "sdb"
    source = google_compute_disk.gce_node.name
    mode = "READ_WRITE" 
  }

  network_interface {
    network = var.compute_network
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
  metadata_startup_script = data.template_file.init.rendered
}

resource "google_compute_firewall" "gce_node" {
  name    = var.gce_node_firewall
  network = var.compute_network

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0", "10.0.0.0/8"]
}

resource "google_compute_disk" "gce_node" {
  name = "datadisk"
  zone = var.zone
  size = var.disk_size
  type = "pd-ssd"
  labels = {
    name = var.instance_name
  }
}

resource "google_compute_attached_disk" "gce_node" {
  disk     = google_compute_disk.gce_node.id
  instance = google_compute_instance.gce_node.id
}

data "template_file" "init" {
  template = file("${path.module}/init.tpl")
  vars = {
    kubernetes_version = var.kubernetes_version
  }
}
