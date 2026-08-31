# Outputs proving the CloudNotes local infrastructure plan succeeded.

output "environment" {
  description = "Deployment environment used for this plan."
  value       = var.environment
}

output "image_tag" {
  description = "Container image tag referenced by the service."
  value       = var.image_tag
}

output "service_name" {
  description = "Name of the CloudNotes API service, from the module."
  value       = module.cloudnotes_service.service_name
}
