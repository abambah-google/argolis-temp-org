data "google_project" "project" {
  project_id = var.project_id
}

resource "google_privateca_ca_pool_iam_member" "workload_requester" {
  ca_pool  = var.ca_pool_name
  location = var.ca_pool_location
  project  = var.project_id
  role     = "roles/privateca.workloadCertificateRequester"
  member   = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_name}"
}

resource "google_privateca_ca_pool_iam_member" "pool_reader" {
  ca_pool  = var.ca_pool_name
  location = var.ca_pool_location
  project  = var.project_id
  role     = "roles/privateca.poolReader"
  member   = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_name}"
}

resource "google_privateca_ca_pool_iam_member" "gke_robot_reader" {
  ca_pool  = var.ca_pool_name
  location = var.ca_pool_location
  project  = var.project_id
  role     = "roles/privateca.poolReader"
  member   = "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_privateca_ca_pool_iam_member" "gke_robot_requester" {
  ca_pool  = var.ca_pool_name
  location = var.ca_pool_location
  project  = var.project_id
  role     = "roles/privateca.workloadCertificateRequester"
  member   = "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "null_resource" "workload_identity_pool_config" {
  triggers = {
    pool_name = var.workload_identity_pool_name
    # Trigger execution whenever the YAML file contents change
    # Force applying it via local-exec since there's no native TF parameter for this inline config yet
  }

  provisioner "local-exec" {
    command = "gcloud iam workload-identity-pools update ${var.workload_identity_pool_name} --location=\"global\" --inline-certificate-issuance-config-file=\"${var.cic_yaml_path}\" --project=\"${var.project_id}\""
  }
}
