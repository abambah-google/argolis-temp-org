output "terraform_sa_email" {
  value = google_service_account.terraform_service_account.email
}

output "custom_sa_emails" {
  value = { for k, v in google_service_account.custom_sas : k => v.email }
}

output "custom_sa_ids" {
  value = { for k, v in google_service_account.custom_sas : k => v.id }
}
