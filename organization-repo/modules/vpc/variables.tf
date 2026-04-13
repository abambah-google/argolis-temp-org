variable "project_id" {
  type        = string
  description = "the project id of the project"
}

variable "region1" {
  type        = string
  description = "only run in one region for now for testing"
  default     = "us-east1"
}
variable "region2" {
  type        = string
  description = "only run in one region for now for testing"
  default     = "us-west1"
}

variable "sub-1" {
  type        = string
  description = "cidr range 1"
  default     = "10.146.0.0/24"
}
variable "sub-2" {
  type        = string
  description = "cidr range 2"
  default     = "10.146.2.0/24"
}

variable "subnetwork1" {
  type = string
}

variable "subnetwork2" {
  type = string
}

variable "ip_range_services1" {
  type    = string
  default = "10.96.0.0/24"
}

variable "ip_range_services2" {
  type    = string
  default = "10.96.2.0/24"
}

variable "ip_range_pods1" {
  type    = string
  default = "10.96.4.0/24"
}

variable "ip_range_pods2" {
  type    = string
  default = "10.96.6.0/24"
}


