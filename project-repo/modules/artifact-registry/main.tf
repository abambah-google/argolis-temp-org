resource "google_artifact_registry_repository" "default" {
  project       = var.project_id
  location      = var.location
  repository_id = "default"
  format        = "DOCKER"
  mode          = "STANDARD_REPOSITORY"

  docker_config {
    immutable_tags = false
  }
}

resource "google_artifact_registry_repository" "dockerio" {
  project       = var.project_id
  location      = var.location
  repository_id = "dockerio"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"

  remote_repository_config {
    docker_repository {
      public_repository = "DOCKER_HUB"
    }
  }
}
