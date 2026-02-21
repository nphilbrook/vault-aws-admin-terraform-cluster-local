terraform {
  cloud {
    organization = "philbrook"

    workspaces {
      project = "AWS Vault Lab"
      # Have to pick one for init/validate local
      name = "vault-aws-admin-terraform-cluster-local-us-west-2"
    }
  }
}
