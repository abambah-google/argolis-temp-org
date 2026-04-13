resource "google_service_account" "accounts" {
  for_each     = toset(var.service_account_names)
  project      = var.project_id
  account_id   = each.key
  display_name = each.key
}
