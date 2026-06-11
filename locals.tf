locals {
  region                      = regex("vault-aws-admin-terraform-(.*)", terraform.workspace)
  dynamic_database_configured = local.region == "us-east-2"
}
