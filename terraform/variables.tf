# Input variables for the CloudNotes local/mock infrastructure.
#
# This configuration never talks to a real cloud provider. All
# resources are `terraform_data` placeholders that model a network,
# an API service, and a registry namespace so students can practice
# real Terraform workflow commands (fmt, validate, plan) at $0 cost.

variable "environment" {
  description = "Deployment environment label (local-only for this exercise)."
  type        = string
  default     = "local"
}

variable "image_tag" {
  description = "Container image tag the CloudNotes API service will reference."
  type        = string
  default     = "cloudnotes-api:0.1.0"
}

# NOTE: main.tf and the module also expect a "service_name" input.
# Look closely at how the module is called in main.tf and compare it
# with the variables declared in this file.
