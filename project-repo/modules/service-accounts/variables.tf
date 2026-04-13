variable "project_id" {
  description = "The project ID to host the service accounts."
  type        = string
}

variable "service_account_names" {
  description = "A list of service account names to create."
  type        = list(string)
}
