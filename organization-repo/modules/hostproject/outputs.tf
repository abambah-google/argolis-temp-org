output "project_id" {
  value       = module.project-factory.project_id
  description = "The ID of the host project"
}

output "project_name" {
  value       = module.project-factory.project_name
  description = "The name of the host project"
}

output "custom_sa_emails" {
  value = module.serviceaccount.custom_sa_emails
}

output "custom_sa_ids" {
  value = module.serviceaccount.custom_sa_ids
}
