resource "google_project" "consumer_project" {
  project_id      = var.consumer_project
  name            = var.customer_project_name
  billing_account = var.billing_account
  # folder_id       = var.folder_name
}

# Enable the Compute Engine API.
resource "google_project_service" "consumer_project_compute_service" {
  project = google_project.consumer_project.project_id
  service = "bigquery.googleapis.com"
}

resource "time_sleep" "wait_90_seconds_enable_compute_api" {
  depends_on      = [google_project_service.consumer_project_compute_service]
  create_duration = "90s"
}
module "bigquery" {
  source      = "../bigquery"
  table-name  = var.table-name
  dataset-id  = var.dataset-id
  location    = var.location
  description = var.description
  project_id  = var.consumer_project
  depends_on  = [google_project.consumer_project, google_project_service.consumer_project_compute_service]
}