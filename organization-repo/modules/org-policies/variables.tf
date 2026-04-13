# Copyright 2024 Google LLC
# Author: abambah@google.com

variable "organization_id" {
  type        = string
  description = "The GCP organization ID to apply org policies to."
}

variable "allowed_policy_domains" {
  type        = list(string)
  description = <<-EOT
    List of Cloud Identity customer IDs to allow as IAM policy members.
    These are in the format 'C0xxxxxxx'. Leave empty to skip this policy.
    Example: ["C0abc1234"]
  EOT
  default     = []
}

variable "allowed_shared_vpc_host_projects" {
  type        = list(string)
  description = <<-EOT
    List of allowed Shared VPC host project resource names in the format
    'projects/PROJECT_NUMBER'. Leave empty to skip this policy.
    Example: ["projects/123456789"]
  EOT
  default     = []
}
