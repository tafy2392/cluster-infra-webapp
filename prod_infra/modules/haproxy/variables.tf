variable "project" {
  type    = string
}

variable "ssh_keys" {
  type = map
}

variable "instance_name" {
  type    = string
  default = "haproxy"
}

variable "instance_type" {
  type    = string
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "disk_size" {
  type    = number
  default = 4
}

variable "haproxy" {
  type    = string
  default = "haproxy"
}

variable "compute_network" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "europe-west1"
}
