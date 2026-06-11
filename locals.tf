locals {
  region                      = regex("vault-aws-admin-terraform-(?P<region>.*)", terraform.workspace)["region"]
  dynamic_database_configured = local.region == "us-east-2"
}

output "region" {
  value = local.region
}