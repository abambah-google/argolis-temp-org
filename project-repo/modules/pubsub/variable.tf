variable "envt" {}
variable "project_id" {
  type        = map(any)
  description = "the project id of the project"
  default = {
    "prod"  = "gvts-prod"
    "stage" = "gvts-stage"
    "core"  = "gvts-core"
  }
}

variable "credentials" {
  type        = map(any)
  description = "GCP credentials file"
  default = {
    "prod"  = "../gvts-prod-fa7cb69d1b74.json"
    "core"  = "../gvts-core-fa7cb69d1b74.json"
    "stage" = "../gvts-stage-fa7cb69d1b74.json"
    "dev"   = "../gvts-dev-fa7cb69d1b74.json"
  }
}