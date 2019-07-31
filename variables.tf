variable "project_id" {}
variable "region" {}
variable "cluster_name" {}
variable "service_range_name" {}
variable "cluster_range_name" {}
variable "network_name" {}
variable "subnetwork_name" {}

variable "gke_version" {
  type    = "string"
  default = ""
}

variable "linux_admin_username" {
  type    = "string"
  default = "admin"
}

variable "linux_admin_password" {
  type    = "string"
  default = ""
}

variable "gcp_cluster_count" {
  type    = "string"
  default = "1"
}

variable "instance_type" {
  type    = "string"
  default = "g1-small"
}

variable "master_authorized_networks_cidr" {
  type    = "string"
  default = "0.0.0.0/0"
}

variable "master_cidr" {
  type    = "string"
  default = "10.11.0.0/28"
}

variable "pool_name" {
  type    = "string"
  default = "default-pool"
}

variable "service_account" {
  default = ""
  type = "string"
}