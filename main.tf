resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.cloud_region

  template {
    spec {
      containers {
        image = var.image_url
        env {
          name  = "ASPNETCORE_URLS"
          value = "http://*:8000"
        }
        env {
          name  = "ASPNETCORE_ENVIRONMENT"
          value = "Development"
        }
        env {
          name  = "MONGODB_URL"
          value = var.mongodb_url
        }
        env {
          name  = "MONGODB_DATABASE_NAME"
          value = var.mongodb_database_name
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
          value = "America/Sao_Paulo"
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

resource "google_secret_manager_secret" "mongodb_secret" {
  name = "mongodb-secret"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mongodb_secret_version" {
  secret = google_secret_manager_secret.mongodb_secret.id

  secret_data = "your-secret-value-here"
}
