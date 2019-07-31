How to use this module
=========
```
module "cicd-gke" {
  source = "git::ssh://git@github.com/awolde/tf-gke-cluster"
  project_id = "your-project-id"
  region = "us-central1"
  cluster_name = "gke-cluster"
  network_name = "your-vpc-name"
  subnetwork_name = "your-subnet-in-vpc"
  service_range_name = "subnet01-secondary01"
  cluster_range_name = "subnet01-secondary02"
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
```

What this module does
=========
This repo creates Google Kubernetes Engine cluster in default network and subnet and adds node pools in different zones
