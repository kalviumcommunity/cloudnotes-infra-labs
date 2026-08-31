# Root Terraform configuration for the CloudNotes local exercise.
#
# Local backend only: this exercise intentionally uses Terraform's
# default local backend (state written to terraform.tfstate on disk).
# A real team project would use a remote backend (e.g. S3+DynamoDB,
# Terraform Cloud) so that state is shared, locked, and kept out of
# source control. We do not configure one here because that would
# require a real cloud account and credentials, which this $0 local
# exercise must avoid.

terraform {
  required_version = ">= 1.4.0"

  # No `required_providers` block is needed: `terraform_data` is a
  # built-in resource type provided by Terraform core itself (since
  # v1.4), so this configuration needs no external provider plugin
  # and no credentials of any kind.
}

module "cloudnotes_service" {
  source = "./modules/cloudnotes-service"

  environment  = var.environment
  service_name = var.service_name
  image_tag    = var.image_tag
}

resource "terraform_data" "registry_namespace" {
  input = {
    namespace   = "cloudnotes-local"
    environment = var.environment
  }
}
