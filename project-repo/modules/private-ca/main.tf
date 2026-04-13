# CA Pools
resource "google_privateca_ca_pool" "cirrus-autos" {
  name     = "cirrus-autos"
  project  = var.project_id
  location = var.location
  tier     = "DEVOPS"
  labels   = var.pool_labels

  issuance_policy {
    identity_constraints {
      allow_subject_alt_names_passthrough = true
      allow_subject_passthrough           = true
      cel_expression {
        expression = "true"
      }
    }
  }

  publishing_options {
    publish_ca_cert = true
    publish_crl     = false
  }
}

resource "google_privateca_ca_pool" "cirrus-clients-uc" {
  name     = "cirrus-clients-uc"
  project  = var.project_id
  location = var.location
  tier     = "DEVOPS"
  labels   = var.pool_labels

  issuance_policy {
    identity_constraints {
      allow_subject_alt_names_passthrough = true
      allow_subject_passthrough           = true
      cel_expression {
        expression = "true"
      }
    }
  }

  publishing_options {
    publish_ca_cert = true
    publish_crl     = false
  }
}

resource "google_privateca_ca_pool" "cirrus-apps-uc" {
  name     = "cirrus-apps-uc"
  project  = var.project_id
  location = var.location
  tier     = "DEVOPS"
  labels   = var.pool_labels

  issuance_policy {
    identity_constraints {
      allow_subject_alt_names_passthrough = true
      allow_subject_passthrough           = true
      cel_expression {
        expression = "true"
      }
    }
  }

  publishing_options {
    publish_ca_cert = true
    publish_crl     = false
  }
}

resource "google_privateca_ca_pool" "cirrus-workload-uc" {
  name     = "cirrus-workload-uc"
  project  = var.project_id
  location = var.location
  tier     = "DEVOPS"
  labels   = var.pool_labels

  issuance_policy {
    identity_constraints {
      allow_subject_alt_names_passthrough = true
      allow_subject_passthrough           = true
      cel_expression {
        expression = "true"
      }
    }
  }

  publishing_options {
    publish_ca_cert = true
    publish_crl     = false
  }
}

# Certificate Authorities
resource "google_privateca_certificate_authority" "cirrus-auto-root" {
  pool                     = google_privateca_ca_pool.cirrus-autos.name
  project                  = var.project_id
  location                 = var.location
  certificate_authority_id = "cirrus-auto-root"
  type                     = "SELF_SIGNED"
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }
  config {
    subject_config {
      subject {
        common_name         = "r.ai.threatspace.com"
        country_code        = "US"
        organization        = "Google"
        organizational_unit = "ThreatSpace"
      }
      subject_alt_name {
        dns_names       = ["r.ai.threatspace.com", "*.r.ai.threatspace.com"]
        email_addresses = ["ts-ai-mvp@threatspace.com", "ops-admin@ts-prot-npp-ai-sec-prd.iam.gserviceaccount.com"]
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          digital_signature  = true
          content_commitment = true
          key_encipherment   = false
          data_encipherment  = false
          key_agreement      = false
          cert_sign          = true
          crl_sign           = true
          encipher_only      = false
          decipher_only      = false
        }
        extended_key_usage {
          server_auth      = false
          client_auth      = false
          code_signing     = false
          email_protection = false
          time_stamping    = false
          ocsp_signing     = false
        }
      }
    }
  }
  lifetime = "166440h" # 19 years
}

resource "google_privateca_certificate_authority" "cirrus-global-root-01" {
  pool                     = google_privateca_ca_pool.cirrus-autos.name
  project                  = var.project_id
  location                 = var.location
  certificate_authority_id = "cirrus-global-root-01"
  type                     = "SELF_SIGNED"
  key_spec {
    algorithm = "EC_P384_SHA384"
  }
  config {
    subject_config {
      subject {
        common_name         = "r.ai.threatspace.com"
        country_code        = "US"
        organization        = "Google"
        organizational_unit = "ThreatSpace"
      }
      subject_alt_name {
        dns_names       = ["r.ai.threatspace.com", "*.r.ai.threatspace.com"]
        email_addresses = ["ts-ai-mvp@threatspace.com", "ops-admin@ts-prot-npp-ai-sec-prd.iam.gserviceaccount.com"]
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          digital_signature  = true
          content_commitment = true
          key_encipherment   = true
          data_encipherment  = true
          key_agreement      = true
          cert_sign          = true
          crl_sign           = true
          encipher_only      = true
          decipher_only      = true
        }
        extended_key_usage {
          server_auth      = true
          client_auth      = true
          code_signing     = true
          email_protection = true
          time_stamping    = true
          ocsp_signing     = true
        }
      }
    }
  }
  lifetime = "166440h" # 19 years
}

resource "google_privateca_certificate_authority" "ai-apps-tspprd-uc-anchor-01" {
  pool                     = google_privateca_ca_pool.cirrus-apps-uc.name
  project                  = var.project_id
  location                 = var.location
  certificate_authority_id = "ai-apps-tspprd-uc-anchor-01"
  type                     = "SUBORDINATE"
  key_spec {
    algorithm = "EC_P256_SHA256"
  }
  config {
    subject_config {
      subject {
        common_name         = "ai-apps-tspprd-uc-anchor-01"
        country_code        = "US"
        organization        = "Google"
        organizational_unit = "ThreatSpace"
      }
      subject_alt_name {
        dns_names       = ["apps.r.ai.threatspace.com", "*.apps.r.ai.threatspace.com"]
        email_addresses = ["ts-ai-mvp@threatspace.com", "ops-admin@ts-prot-npp-ai-sec-prd.iam.gserviceaccount.com"]
      }
    }
    x509_config {
      ca_options {
        is_ca                  = true
        max_issuer_path_length = 4
      }
      key_usage {
        base_key_usage {
          digital_signature  = true
          content_commitment = true
          key_encipherment   = true
          data_encipherment  = true
          key_agreement      = true
          cert_sign          = true
          crl_sign           = true
        }
        extended_key_usage {
          server_auth   = true
          client_auth   = true
          time_stamping = true
          ocsp_signing  = true
        }
      }
    }
  }
  lifetime = "87600h" # 10 years
  subordinate_config {
    certificate_authority = google_privateca_certificate_authority.cirrus-auto-root.name
  }
}

resource "google_privateca_certificate_authority" "ai-clients-tspprd-uc-anchor-01" {
  pool                     = google_privateca_ca_pool.cirrus-clients-uc.name
  project                  = var.project_id
  location                 = var.location
  certificate_authority_id = "ai-clients-tspprd-uc-anchor-01"
  type                     = "SUBORDINATE"
  key_spec {
    algorithm = "EC_P384_SHA384"
  }
  config {
    subject_config {
      subject {
        common_name         = "ai-clients-tspprd-uc-anchor-01"
        country_code        = "US"
        organization        = "Google"
        organizational_unit = "ThreatSpace"
      }
      subject_alt_name {
        dns_names       = ["clients.r.ai.threatspace.com"]
        email_addresses = ["ts-ai-mvp@threatspace.com", "ops-admin@ts-prot-npp-ai-sec-prd.iam.gserviceaccount.com"]
      }
    }
    x509_config {
      ca_options {
        is_ca                  = true
        max_issuer_path_length = 4
      }
      key_usage {
        base_key_usage {
          digital_signature  = true
          content_commitment = true
          key_encipherment   = true
          data_encipherment  = true
          key_agreement      = true
          cert_sign          = true
          crl_sign           = true
          encipher_only      = true
          decipher_only      = true
        }
        extended_key_usage {
          server_auth      = true
          client_auth      = true
          code_signing     = true
          email_protection = true
          time_stamping    = true
          ocsp_signing     = true
        }
      }
    }
  }
  lifetime = "87600h" # 10 years
  subordinate_config {
    certificate_authority = google_privateca_certificate_authority.cirrus-global-root-01.name
  }
}

resource "google_privateca_certificate_authority" "ai-workload-tspprd-uc-anchor-01" {
  pool                     = google_privateca_ca_pool.cirrus-workload-uc.name
  project                  = var.project_id
  location                 = var.location
  certificate_authority_id = "ai-workload-tspprd-uc-anchor-01"
  type                     = "SUBORDINATE"
  key_spec {
    algorithm = "EC_P256_SHA256"
  }
  config {
    subject_config {
      subject {
        common_name         = "ai-workload-tspprd-uc-anchor-01"
        country_code        = "US"
        organization        = "Google"
        organizational_unit = "ThreatSpace"
      }
      subject_alt_name {
        uris            = ["spiffe://ts-prot-npp-ai-sec-prd.svc.id.goog/*"]
        email_addresses = ["ts-ai-mvp@threatspace.com", "ops-admin@ts-prot-npp-ai-sec-prd.iam.gserviceaccount.com"]
      }
    }
    x509_config {
      ca_options {
        is_ca                  = true
        max_issuer_path_length = 2
      }
      key_usage {
        base_key_usage {
          digital_signature = true
          key_encipherment  = true
          key_agreement     = true
        }
        extended_key_usage {
          server_auth = true
          client_auth = true
        }
      }
    }
  }
  lifetime = "87600h" # 10 years
  subordinate_config {
    certificate_authority = google_privateca_certificate_authority.cirrus-global-root-01.name
  }
}

# Certificates
resource "google_privateca_certificate" "guard-uc-sign-kms-tspprd-01" {
  name                  = "guard-uc-sign-kms-tspprd-01"
  project               = var.project_id
  pool                  = google_privateca_ca_pool.cirrus-apps-uc.name
  location              = var.location
  certificate_authority = google_privateca_certificate_authority.ai-apps-tspprd-uc-anchor-01.certificate_authority_id
  lifetime              = "43800h" # 5 years
  config {
    subject_config {
      subject {
        common_name         = "pyful-guard"
        country_code        = "US"
        organization        = "Google"
        organizational_unit = "ThreatSpace"
      }
      subject_alt_name {
        dns_names       = ["guard.r.ai.threatspace.com", "armor.r.ai.threatspace.com"]
        email_addresses = ["ts-ai-mvp@threatspace.com", "ops-admin@ts-prot-npp-ai-sec-prd.iam.gserviceaccount.com"]
      }
    }
    x509_config {
      key_usage {
        base_key_usage {
          digital_signature  = true
          content_commitment = true
          key_encipherment   = true
          data_encipherment  = true
          key_agreement      = true
          crl_sign           = true
        }
        extended_key_usage {
          server_auth      = true
          client_auth      = true
          code_signing     = true
          email_protection = true
          time_stamping    = true
          ocsp_signing     = true
        }
      }
    }
    public_key {
      format = "PEM"
      key    = "" # KMS key
    }
  }
}

resource "google_privateca_certificate" "agents-uc-client-mtls-tspprd-01" {
  name                  = "agents-uc-client-mtls-tspprd-01"
  project               = var.project_id
  pool                  = google_privateca_ca_pool.cirrus-clients-uc.name
  location              = var.location
  certificate_authority = google_privateca_certificate_authority.ai-clients-tspprd-uc-anchor-01.certificate_authority_id
  lifetime              = "43800h" # 5 years
  config {
    subject_config {
      subject {
        common_name         = "pyful-agents"
        country_code        = "US"
        organization        = "Google"
        organizational_unit = "ThreatSpace"
      }
      subject_alt_name {
        dns_names       = ["agents.r.ai.threatspace.local"]
        email_addresses = ["ts-ai-mvp@threatspace.com", "ops-admin@ts-prot-npp-ai-sec-prd.iam.gserviceaccount.com"]
      }
    }
    x509_config {
      key_usage {
        base_key_usage {
          digital_signature  = true
          content_commitment = true
          key_encipherment   = true
          data_encipherment  = true
          key_agreement      = true
          encipher_only      = true
          decipher_only      = true
        }
        extended_key_usage {
          server_auth      = true
          client_auth      = true
          email_protection = true
        }
      }
    }
    public_key {
      format = "PEM"
    }
  }
}

resource "google_privateca_certificate" "agents-spiffe-tspprd-01" {
  name                  = "agents-spiffe-tspprd-01"
  project               = var.project_id
  pool                  = google_privateca_ca_pool.cirrus-workload-uc.name
  location              = var.location
  certificate_authority = google_privateca_certificate_authority.ai-workload-tspprd-uc-anchor-01.certificate_authority_id
  lifetime              = "43800h" # 5 years
  config {
    subject_config {
      subject {
        common_name         = "pyful-agents"
        country_code        = "US"
        organization        = "Google"
        organizational_unit = "ThreatSpace"
      }
      subject_alt_name {
        uris = ["spiffe://ts-prot-npp-ai-sec-prd.svc.id.goog/ns/pycloud/sa/pyful-agents"]
      }
    }
    x509_config {
      key_usage {
        base_key_usage {
          digital_signature = true
          key_encipherment  = true
          key_agreement     = true
        }
        extended_key_usage {
          server_auth = true
          client_auth = true
        }
      }
    }
    public_key {
      format = "PEM"
    }
  }
}

# Certificate Manager
resource "google_certificate_manager_trust_config" "cirrus-cas-default" {
  name        = "cirrus-cas-default"
  project     = var.project_id
  location    = "global"
  description = "Cirrus CAS Default Trust Config"
  trust_stores {
    trust_anchors {
      pem_certificate = google_privateca_certificate_authority.cirrus-global-root-01.pem_ca_certificates[0]
    }
    intermediate_cas {
      pem_certificate = google_privateca_certificate_authority.ai-clients-tspprd-uc-anchor-01.pem_ca_certificates[0]
    }
  }
}

# Network Security
resource "google_network_security_server_tls_policy" "cirrus-mtls-cas" {
  name     = "cirrus-mtls-cas"
  project  = var.project_id
  location = "global"
  mtls_policy {
    client_validation_ca {
      certificate_provider_instance {
        plugin_instance = "google_cloud_private_ca"
      }
    }
  }
}
