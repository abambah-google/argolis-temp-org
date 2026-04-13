locals {
  # Flatten the service_accounts map into a list of objects
  project_sa_bindings = flatten([
    for sa_name, roles in var.service_accounts : [
      for role in roles : {
        sa_name = sa_name
        role    = role
      }
    ]
  ])
  # Flatten the gcp_service_accounts map into a list of objects
  gcp_sa_bindings = flatten([
    for sa_name, roles in var.gcp_service_accounts : [
      for role in roles : {
        sa_name = sa_name
        role    = role
      }
    ]
  ])
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_iam_member" "project_service_account_roles" {
  for_each = {
    for binding in local.project_sa_bindings : "${binding.sa_name}.${binding.role}" => binding
  }
  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${lookup(var.custom_sa_emails, each.value.sa_name, "${each.value.sa_name}@${var.project_id}.iam.gserviceaccount.com")}"
}

resource "google_project_iam_member" "gcp_service_account_roles" {
  for_each = {
    for binding in local.gcp_sa_bindings : "${binding.sa_name}.${binding.role}" => binding
  }
  project = var.project_id
  role    = each.value.role
  member  = each.value.sa_name == "cloudservices" ? "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com" : "serviceAccount:service-${data.google_project.project.number}@${each.value.sa_name}.iam.gserviceaccount.com"
}

# Impersonation roles
resource "google_service_account_iam_member" "default_gce_token_creator" {
  service_account_id = lookup(var.custom_sa_ids, "default-gce", "projects/${var.project_id}/serviceAccounts/default-gce@${var.project_id}.iam.gserviceaccount.com")
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${lookup(var.custom_sa_emails, "default-apps", "default-apps@${var.project_id}.iam.gserviceaccount.com")}"
}

resource "google_service_account_iam_member" "default_apps_token_creator" {
  service_account_id = lookup(var.custom_sa_ids, "default-apps", "projects/${var.project_id}/serviceAccounts/default-apps@${var.project_id}.iam.gserviceaccount.com")
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-aiplatform-re.iam.gserviceaccount.com"
}
resource "google_project_iam_member" "additional_sa_network_user" {
  for_each = toset(var.additional_service_accounts)
  project  = var.project_id
  role     = "roles/compute.networkUser"
  member   = "serviceAccount:${each.value}"
}
