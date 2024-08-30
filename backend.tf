# Se especifica el backend para el estado de Terraform, en este caso un bucket S3.
terraform {
  backend "s3" {
    bucket               = "bcpl-s3-nonprod-dev-terraform-state"
    key                  = "tfstate/networking-apificacion.tfstate"
    workspace_key_prefix = "UnityHA"
    region               = "us-east-1"
    endpoints = {
      s3 = "https://s3.us-east-1.amazonaws.com"
    }
  }
}