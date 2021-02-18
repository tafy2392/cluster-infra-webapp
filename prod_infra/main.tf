module "gke_node" {
  source = "./modules/gce_node"

  project         = var.project
  compute_network = var.compute_network
  instance_type   = var.instance_type
  ssh_keys        = var.ssh_keys
  kubernetes_version = var.kubernetes_version
}

module "haproxy" {
  source = "./modules/haproxy"

  project         = var.project
  compute_network = var.compute_network
  instance_type   = var.instance_type
  ssh_keys        = var.ssh_keys
}

provider "google" {
  project = var.project
  version = "~> 3.15"
  region  = var.region
}
