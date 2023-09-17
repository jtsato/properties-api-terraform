variable "credentials_path" {
  description = "The path to the Google Cloud credentials JSON file."
  type        = string
}

variable "project_id" {
  description = "The ID of the project to apply any resources to."
  type        = string
}

variable "project_name" {
  description = "Cloud project name"
  type        = string
}

variable "cloud_region" {
  description = "The region to deploy to."
  type        = string
}

variable "zone" {
  description = "Cloud zone"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service."
  type        = string
}

variable "image_url" {
  description = "URL of the Docker image to deploy."
  type        = string
}

variable "MONGODB_URL" {
  description = "MongoDB URL."
  type        = string
}

variable "MONGODB_DATABASE" {
  description = "MongoDB database name."
  type        = string
}

variable "PROPERTY_COLLECTION_NAME" {
  description = "Property collection name."
  type        = string
}

variable "property_sequence_collection_name" {
  description = "Property sequence collection name."
  type        = string
}
