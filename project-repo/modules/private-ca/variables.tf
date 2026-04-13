variable "project_id" {
  type        = string
  description = "The project ID to create the Private CA resources in."
  default     = "ts-prot-npp-ai-sec-prd"
}

variable "location" {
  type        = string
  description = "The location for the Private CA resources."
  default     = "us-central1"
}

variable "pool_labels" {
  type = map(any)
  default = {
    "pool"        = "cirrus-autos-uc",
    "cert-family" = "ca",
    "cert-class"  = "devops",
    "env"         = "pprd"
  }
}
