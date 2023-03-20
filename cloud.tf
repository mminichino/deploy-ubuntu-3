# Terraform Cloud

terraform {
  cloud {
    organization = "mm-orcd"

    workspaces {
      name = "deploy-ubuntu-3"
    }
  }
}
