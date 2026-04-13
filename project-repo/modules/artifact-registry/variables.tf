variable "project_id" {
  type        = string
  description = "The project ID to create the Artifact Registry repositories in."
}

variable "location" {
  type        = string
  description = "The location for the Artifact Registry repositories."
  default     = "us"
}
