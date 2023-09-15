variable "project_name" {
  description = "Cloud project name"
  type        = string
}

variable "region" {
  description = "Cloud region"
  type        = string
  default     = "southamerica-east1"
}

variable "zone" {
  description = "Cloud zone"
  type        = string
  default     = "southamerica-east1-b"
}