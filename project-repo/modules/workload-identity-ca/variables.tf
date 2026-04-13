variable "project_id" {
  type        = string
  description = "The project ID"
}

variable "ca_pool_name" {
  type        = string
  description = "The CA pool name"
}

variable "ca_pool_location" {
  type        = string
  description = "The CA pool location"
  default     = "us-central1"
}

variable "workload_identity_pool_name" {
  type        = string
  description = "The workload identity pool name (e.g. project-id.svc.id.goog)"
}

variable "cic_yaml_path" {
  type        = string
  description = "Path to the inline certificate issuance config yaml file"
}
