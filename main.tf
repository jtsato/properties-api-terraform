resource "google_cloud_run_service" "default" {

  depends_on = [
    google_service_account_iam_member.iam_member,
    google_service_account_iam_binding.act_as_iam,
  ]

  name     = var.service_name
  location = var.cloud_region
  project  = var.project_id

  template {
    spec {
      service_account_name = var.service_name

      containers {
        image = var.image_url

        ports {
          container_port = 80
        }

        env {
          name  = "ASPNETCORE_URLS"
          value = join(",", var.aspnetcore_urls)
        }
        env {
          name  = "ASPNETCORE_ENVIRONMENT"
          value = var.aspnetcore_environment
        }
        env {
          name  = "MONGODB_URL"
          value = var.mongodb_url
        }
        env {
          name  = "MONGODB_DATABASE"
          value = var.mongodb_database
        }
        env {
          name  = "PROPERTY_COLLECTION_NAME"
          value = var.property_collection_name
        }
        env {
          name  = "PROPERTY_SEQUENCE_COLLECTION_NAME"
          value = var.property_sequence_collection_name
        }
        env {
          name  = "TZ"
          value = var.tz
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "5"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_service_account" "default_service_account" {
  account_id   = var.service_name
  display_name = var.service_name
  project      = data.google_project.project.project_id
}

resource "google_service_account_iam_binding" "act_as_iam" {
  service_account_id = google_service_account.default_service_account.name
  role               = "roles/iam.serviceAccountUser"
  members = [
    "serviceAccount:${google_service_account.default_service_account.email}",
  ]
}

resource "google_service_account_iam_member" "iam_member" {
  service_account_id = google_service_account.default_service_account.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.default_service_account.email}"
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"

    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location

  policy_data = data.google_iam_policy.noauth.policy_data
}

# gsutil mb -p duckhome-firebase -c STANDARD -l southamerica-east1 gs://duckhome-prp-terraform-state
terraform {
  backend "gcs" {
    bucket = "duckhome-prp-terraform-state"
    prefix = "terraform/state"
  }
}

resource "google_secret_manager_secret" "mongodb_url" {
  project   = var.project_id
  secret_id = "mongodb_url"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mongodb_database" {
  project   = var.project_id
  secret_id = "mongodb_database"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "property_collection_name" {
  project   = var.project_id
  secret_id = "property_collection_name"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "property_sequence_collection_name" {
  project   = var.project_id
  secret_id = "property_sequence_collection_name"
  replication {
    auto {}
  }
}