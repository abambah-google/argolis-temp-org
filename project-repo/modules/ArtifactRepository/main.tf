resource "google_artifact_registry_repository" "artifactory_repository" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repo_id
  format        = var.format
  description   = var.description
}
