resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.cloud_region
  project  = var.project_id

  template {
    spec {
      service_account_name = var.service_name
      containers {
        image = var.image_url
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
        "autoscaling.knative.dev/maxScale" = "1000"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    ignore_changes = [template]
  }
}

resource "google_secret_manager_secret" "mongodb_url" {
  project = var.project_id
  secret_id = "mongodb_url"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "mongodb_database" {
  project = var.project_id
  secret_id = "mongodb_database"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "property_collection_name" {
  project = var.project_id
  secret_id = "property_collection_name"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "property_sequence_collection_name" {
  project = var.project_id
  secret_id = "property_sequence_collection_name"
  replication {
    automatic = true
  }
}
