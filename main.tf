resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.cloud_region

  template {
    spec {
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

resource "google_secret_manager_secret" "properties_api_secrets" {
  secret_id = "properties_api_secrets"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "properties_api_secrets_version" {
  secret = google_secret_manager_secret.properties_api_secrets.id
  secret_data = "{\"MONGODB_URL\":\"${var.mongodb_url}\",\"MONGODB_DATABASE\":\"${var.mongodb_database}\",\"PROPERTY_COLLECTION_NAME\":\"${var.property_collection_name}\",\"PROPERTY_SEQUENCE_COLLECTION_NAME\":\"${var.property_sequence_collection_name}\"}"
}
