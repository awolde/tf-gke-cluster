provider "google" {
  credentials = "${var.gcp_credentials_file}"
}

variable "gcp_credentials_file" {}

module "cicd-gke" {
  source = "../"
  project_id = "your-project-id"
  cluster_name = "gke-cluster"
  region = "us-central1"
  network_name = "default"
  subnetwork_name = "subnet01"
  cluster_range_name = "subnet01-secondary01"
  service_range_name = "subnet01-secondary02"
}

output "cluster_name" {
  value = "${module.cicd-gke.name}"
}

output "endpoint" {
  value = "${module.cicd-gke.endpoint}"
}

output "ca_certificate" {
  value = "${module.cicd-gke.ca_certificate}"
}
