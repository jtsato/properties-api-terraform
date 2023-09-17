terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.54.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_path)
  project     = var.project_id
}
