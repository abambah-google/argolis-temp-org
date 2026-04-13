variable "consumer_project" {
  type = string
  #default     = "${organization_id}-consumer-project"
  description = "globally unique id of consumer project a to be created"
}
variable "billing_account" {
  type = string
}
variable "table-name" {
  type = string
}

variable "dataset-id" {
  type = string
}

variable "location" {
  type = string
}

variable "description" {
  type = string
}

# variable "folder_name" {
#   type = string
# }
variable "customer_project_name" {
  type = string
}