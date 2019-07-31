# create default service account if one has not been supplied
resource "google_service_account" "jenkins_sa" {
  #count = "${var.service_account == "" ? 1 : 0}"
  #count = 0
  account_id = "jenkins-service-account"
  display_name = "jenkins-service-account"
  project = "${var.project_id}"
}

data "google_container_engine_versions" "versions" {
  region  = "${var.region}"
  project = "${var.project_id}"
}

resource "random_string" "pass" {
  length = 16
}

resource "google_container_cluster" "gcp_kubernetes" {
  name       = "${var.cluster_name}"
  project    = "${var.project_id}"
  region     = "${var.region}"
  network    = "${var.network_name}"
  subnetwork = "${var.subnetwork_name}"

  private_cluster_config = {
    enable_private_nodes   = "true"
    master_ipv4_cidr_block = "${var.master_cidr}"
  }

  ip_allocation_policy {
    cluster_secondary_range_name = "${var.cluster_range_name}"
    services_secondary_range_name = "${var.service_range_name}"
  }

  min_master_version = "${var.gke_version == "" ? data.google_container_engine_versions.versions.latest_node_version : var.gke_version }"
  node_version       = "${var.gke_version == "" ? data.google_container_engine_versions.versions.latest_node_version : var.gke_version }"
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "${var.master_authorized_networks_cidr}"
    }
  }
  master_auth {
    username = "${var.linux_admin_username}"
    password = "${random_string.pass.result}"

    client_certificate_config {
      issue_client_certificate = false
    }
  }
  network_policy {
    enabled = true
    provider = "CALICO"
  }
  node_pool {
    name               = "${var.pool_name}"
    initial_node_count = "${var.gcp_cluster_count}"

    node_config {
      machine_type = "${var.instance_type}"

      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]

      metadata {
        disable-legacy-endpoints = "true"
      }

      labels {
        this-is-for = "${var.project_id}-k8s-${var.region}-cluster"
      }
      service_account = "${var.service_account == "" ? google_service_account.jenkins_sa.email : var.service_account}"

      tags = ["jenkins", "ci-cd"]
    }

    management {
      auto_upgrade = true
    }
  }
  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = false
    }
  }
}

# grant the service account perm to pull down images from GCR, stackdriver logging and monitoring
resource "google_project_iam_member" "storage_viewer" {
  member  = "serviceAccount:${google_service_account.jenkins_sa.email}"
  role    = "roles/storage.admin"
  project = "${var.project_id}"
}


resource "google_project_iam_member" "log_writer" {
  member  = "serviceAccount:${google_service_account.jenkins_sa.email}"
  role    = "roles/logging.logWriter"
  project = "${var.project_id}"
}

resource "google_project_iam_member" "metric_writer" {
  member  = "serviceAccount:${google_service_account.jenkins_sa.email}"
  role    = "roles/monitoring.metricWriter"
  project = "${var.project_id}"
}
