terraform {
}


data "google_client_config" "default" {
}

resource "google_container_cluster" "primary" {
  name                     = var.gke_cluster_name
  location                 = var.region1
  remove_default_node_pool = true
  initial_node_count       = 1
  project                  = var.project_id
  network                  = var.vpc_name1
  subnetwork               = var.subnetwork1
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.59.0.0/20"
    services_ipv4_cidr_block = "10.57.0.0/20"
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.55.0.0/28"
  }
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  maintenance_policy {
    daily_maintenance_window {
      start_time = "09:00"
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = format("%s-%s", var.project_id, "prod-node-pool")
  location   = var.region1
  cluster    = google_container_cluster.primary.name
  node_count = 1
  project    = var.project_id
  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "false"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  autoscaling {
    min_node_count = var.gke_minimal_worknode_count
    max_node_count = var.gke_maximum_worknode_count
  }
  timeouts {
    create = "90m"
    update = "50m"
  }
}

resource "google_container_cluster" "secondary" {
  name                     = var.gke_cluster_name
  location                 = var.region2
  remove_default_node_pool = true
  initial_node_count       = 1
  project                  = var.project_id
  network                  = var.vpc_name1
  subnetwork               = var.subnetwork2
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.69.0.0/20"
    services_ipv4_cidr_block = "10.67.0.0/20"
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.65.0.0/28"
  }
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  maintenance_policy {
    daily_maintenance_window {
      start_time = "09:00"
    }
  }
}

resource "google_container_node_pool" "secondary_nodes" {
  name       = format("%s-%s", var.project_id, "prod-node-pool2")
  location   = var.region2
  cluster    = google_container_cluster.secondary.name
  node_count = 1
  project    = var.project_id
  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "false"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  autoscaling {
    min_node_count = var.gke_minimal_worknode_count
    max_node_count = var.gke_maximum_worknode_count
  }
  timeouts {
    create = "90m"
    update = "50m"
  }
}