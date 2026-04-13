variable "project_id" {
  type        = string
  description = "The project ID to apply IAM policies to."
}

variable "service_accounts" {
  type        = map(list(string))
  description = "A map of service accounts and their roles."
  default = {
    "default-apps" = [
      "roles/artifactregistry.reader",
      "roles/secretmanager.secretAccessor",
      "roles/parametermanager.parameterAccessor",
      "roles/runtimeconfig.admin",
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
      "roles/stackdriver.resourceMetadata.writer",
      "roles/monitoring.viewer",
      "roles/cloudtrace.agent",
      "roles/cloudprofiler.agent",
      "roles/clouddebugger.agent",
      "roles/bigquery.user",
      "roles/bigquery.dataEditor",
      "roles/cloudfunctions.invoker",
      "roles/run.invoker",
      "roles/cloudsql.client",
      "roles/cloudsql.instanceUser",
      "roles/storage.objectCreator",
      "roles/storage.objectViewer",
      "roles/dlp.reader",
      "roles/dlp.inspectTemplatesReader",
      "roles/cloudtranslate.user",
      "roles/documentai.apiUser",
      "roles/aiplatform.user",
      "roles/modelarmor.floorSettingsViewer",
      "roles/serviceusage.serviceUsageConsumer",
      "roles/modelarmor.user",
      "roles/modelarmor.viewer",
      "roles/firebase.developViewer",
      "roles/datastore.user",
      "roles/pubsub.viewer",
      "roles/pubsub.subscriber",
      "roles/pubsub.publisher",
      "roles/cloudkms.cryptoKeyEncrypterDecrypter",
      "roles/cloudkms.signerVerifier",
      "roles/enterpriseknowledgegraph.viewer",
      "roles/iap.httpsResourceAccessor",
      "roles/iam.serviceAccountTokenCreator",
      "roles/discoveryengine.user",
      "roles/privateca.certificateManager",
      "roles/aiplatform.memoryUser"
    ],
    "bastion" = [
      "roles/artifactregistry.writer",
      "roles/compute.instanceAdmin",
      "roles/container.admin",
      "roles/container.clusterViewer",
      "roles/gkehub.admin",
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
      "roles/monitoring.viewer",
      "roles/pubsub.editor",
      "roles/run.admin",
      "roles/cloudfunctions.admin",
      "roles/storage.objectAdmin",
      "roles/cloudsql.editor",
      "roles/run.invoker",
      "roles/iap.httpsResourceAccessor",
      "roles/aiplatform.user",
      "roles/notebooks.admin",
      "roles/modelarmor.admin",
      "roles/iam.serviceAccountTokenCreator"
    ],
    "ops-admin" = [
      "roles/editor",
      "roles/artifactregistry.admin",
      "roles/containeranalysis.admin",
      "roles/bigquery.admin",
      "roles/ml.admin",
      "roles/privateca.admin",
      "roles/cloudasset.owner",
      "roles/cloudfunctions.admin",
      "roles/cloudkms.admin",
      "roles/cloudkms.signerVerifier",
      "roles/cloudkms.cryptoKeyEncrypterDecrypter",
      "roles/run.admin",
      "roles/runtimeconfig.admin",
      "roles/cloudsql.admin",
      "roles/datastore.owner",
      "roles/cloudtranslate.admin",
      "roles/workstations.admin",
      "roles/compute.admin",
      "roles/compute.networkAdmin",
      "roles/compute.instanceAdmin",
      "roles/discoveryengine.admin",
      "roles/dlp.admin",
      "roles/documentai.admin",
      "roles/eventarc.admin",
      "roles/firebase.admin",
      "roles/gkehub.admin",
      "roles/iap.admin",
      "roles/iap.settingsAdmin",
      "roles/iap.httpsResourceAccessor",
      "roles/iap.tunnelResourceAccessor",
      "roles/identityplatform.admin",
      "roles/container.admin",
      "roles/logging.admin",
      "roles/modelarmor.admin",
      "roles/modelarmor.floorSettingsAdmin",
      "roles/modelarmor.viewer",
      "roles/monitoring.admin",
      "roles/notebooks.admin",
      "roles/osconfig.admin",
      "roles/pubsub.admin",
      "roles/secretmanager.admin",
      "roles/parametermanager.admin",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountKeyAdmin",
      "roles/iam.serviceAccountUser",
      "roles/iam.serviceAccountTokenCreator",
      "roles/serviceusage.serviceUsageAdmin",
      "roles/storage.admin",
      "roles/resourcemanager.tagAdmin",
      "roles/aiplatform.admin",
      "roles/enterpriseknowledgegraph.admin",
      "roles/vpcaccess.admin",
      "roles/servicenetworking.networksAdmin",
      "roles/aiplatform.memoryUser",
      "roles/iam.workloadIdentityPoolAdmin"
    ],
    "default-gce" = [
      "roles/artifactregistry.reader",
      "roles/compute.networkViewer",
      "roles/compute.viewer",
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
      "roles/monitoring.viewer",
      "roles/storage.objectViewer"
    ],
    "default-gke" = [
      "roles/artifactregistry.reader",
      "roles/compute.networkViewer",
      "roles/logging.logWriter",
      "roles/cloudtrace.agent",
      "roles/monitoring.metricWriter",
      "roles/monitoring.viewer",
      "roles/storage.objectViewer",
      "roles/gkehub.connect",
      "roles/pubsub.publisher",
      "roles/run.invoker",
      "roles/cloudfunctions.invoker",
      "roles/autoscaling.metricsWriter"
    ],
    "builds" = [
      "roles/cloudbuild.builds.builder",
      "roles/artifactregistry.repoAdmin",
      "roles/run.admin",
      "roles/cloudfunctions.developer",
      "roles/container.developer",
      "roles/cloudbuild.workerPoolUser",
      "roles/secretmanager.secretAccessor",
      "roles/iam.serviceAccountUser",
      "roles/cloudkms.signerVerifier"
    ],
    "events" = [
      "roles/pubsub.editor",
      "roles/storage.objectViewer",
      "roles/cloudtrace.agent",
      "roles/monitoring.metricWriter",
      "roles/eventarc.eventReceiver",
      "roles/run.invoker",
      "roles/cloudfunctions.invoker"
    ],
    "dns-admin" = [
      "roles/dns.admin"
    ]
  }
}

variable "gcp_service_accounts" {
  type        = map(list(string))
  description = "A map of gcp service accounts and their roles."
  default = {
    "gcp-sa-privateca" = [
      "roles/cloudkms.signerVerifier",
      "roles/viewer",
      "roles/storage.objectAdmin",
      "roles/privateca.serviceAgent",
      "roles/cloudkms.cryptoKeyEncrypterDecrypter"
    ],
    "gcp-sa-iap" = [
      "roles/run.invoker"
    ],
    "container-engine-robot" = [
      "roles/cloudkms.cryptoKeyEncrypterDecrypter",
      "roles/compute.networkUser",
      "roles/container.hostServiceAgentUser"
    ],
    "gcp-sa-servicemesh" = [
      "roles/anthosservicemesh.serviceAgent"
    ],
    "gcp-sa-dep" = [
      "roles/container.admin",
      "roles/modelarmor.calloutUser",
      "roles/serviceusage.serviceUsageConsumer",
      "roles/modelarmor.user"
    ],
    "gcp-sa-aiplatform" = [
      "roles/modelarmor.user"
    ],
    "gcp-sa-aiplatform-re" = [
      "roles/aiplatform.user",
      "roles/storage.admin",
      "roles/secretmanager.secretAccessor",
      "roles/modelarmor.user",
      "roles/run.invoker",
      "roles/browser",
      "roles/privateca.certificateManager"
    ],
    "cloudservices" = [
      "roles/compute.networkUser"
    ]
  }
}

variable "additional_service_accounts" {
  type        = list(string)
  description = "A list of additional service account emails to grant roles to (e.g. from other projects)."
  default     = []
}

variable "custom_sa_emails" {
  type        = map(string)
  description = "A map of custom service account emails from the serviceAccount module."
  default     = {}
}

variable "custom_sa_ids" {
  type        = map(string)
  description = "A map of custom service account IDs from the serviceAccount module."
  default     = {}
}
