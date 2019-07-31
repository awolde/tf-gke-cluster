provider "google" {
  credentials = "${var.gcp_credentials_file}"
  region      = "us-central1"
}

variable "gcp_credentials_file" {}

module "cicd_gke" {
  source             = "../"
  project_id         = "cicd-proj-kickstart-d4lu"
  region             = "us-central1"
  network_name       = "default"
  subnetwork_name    = "subnet01"
  service_range_name = "subnet01-secondary01"
  cluster_name       = "gke-cluster"
  cluster_range_name = "subnet01-secondary02"
  instance_type      = "n1-standard-1"
}

output "cluster_name" {
  value = "${module.cicd_gke.name}"
}

output "gke_endpoint" {
  value = "${module.cicd_gke.endpoint}"
}
