
variable "region1" {
  default = "us-east1"
}
variable "region2" {
  default = "us-west1"
}


variable "project_id" {
  type        = string
  description = "the project id of the project"
}


variable "vpc_name1" {
  type = string
}
variable "subnetwork1" {
  type = string

}

variable "subnetwork2" {
  type = string
}

variable "vpc_name2" {
  type = string
}



variable "gke_cluster_name" {
  type = string
}
variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  default     = "subnet-01-secondary-pods"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for pods"
  default     = "subnet-01-secondary-services"
}

variable "gke_minimal_worknode_count" {
  type    = string
  default = "1"
}
variable "gke_maximum_worknode_count" {
  type    = string
  default = "5"
}