# Reusable module: models a CloudNotes network, API service, and
# registry namespace using local-only `terraform_data` resources.
# No external provider or credentials are required.

variable "environment" {
  description = "Deployment environment label."
  type        = string
}

variable "service_name" {
  description = "Logical name of the CloudNotes API service."
  type        = string
}

variable "image_tag" {
  description = "Container image tag associated with this service."
  type        = string
}

resource "terraform_data" "network" {
  input = {
    name        = "${var.service_name}-network"
    environment = var.environment
  }
}

resource "terraform_data" "service" {
  input = {
    name        = var.service_name
    environment = var.environment
    image_tag   = var.image_tag
  }

  depends_on = [terraform_data.network]
}

resource "terraform_data" "registry_namespace" {
  input = {
    namespace = "cloudnotes-local"
  }
}

output "service_name" {
  description = "Name of the CloudNotes API service resource."
  value       = var.service_name
}

output "network_name" {
  description = "Name of the mock CloudNotes network resource."
  value       = "${var.service_name}-network"
}
