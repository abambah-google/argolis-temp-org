# Copyright 2024 Google LLC
# Firewall module — variables
# NOTE: The embedded provider/backend blocks were removed.
# These belong in the root module, not in child modules.

variable "project_id" {
  type        = string
  description = "The project ID in which to create the firewall rules."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC network to apply firewall rules to."
  default     = "custom-network-sample"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}
