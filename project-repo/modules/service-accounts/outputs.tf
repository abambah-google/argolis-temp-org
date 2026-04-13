output "service_account_emails" {
  description = "The email addresses of the created service accounts."
  value       = [for account in google_service_account.accounts : account.email]
}
