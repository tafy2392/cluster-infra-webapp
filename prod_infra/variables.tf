variable "project" {
  type = string
}

variable "ssh_keys" {
  type = map
}

variable "instance_type" {
  type = string
}

variable "compute_network" {
  type = string
}

variable "region" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "haproxy_instance_type" {
  type = string
}
