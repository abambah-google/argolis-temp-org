terraform {
  backend "gcs" {
    bucket = "tf-ai-host-project5-tf-state-tfstate"
    prefix = "terraform/org-state"
  }
}
