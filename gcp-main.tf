resource "google_artifact_registry_repository" "properties-repository" {
  location = var.region
  repository_id = "devopslab-9aso"
  description = "Imagens Docker"
  format = "DOCKER"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
