output "endpoint" {
  value = "${google_container_cluster.gcp_kubernetes.endpoint}"
}

output "ca_certificate" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.cluster_ca_certificate}"
}

output "name" {
  value = "${google_container_cluster.gcp_kubernetes.name}"
}

output "username" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.username}"
}

output "client_certificate" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.client_key}"
}

output "password" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.password}"
}
