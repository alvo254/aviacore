# terraform {
#   required_version = ">= 1.1.0"
#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "alvo"
#     workspaces {
#       name = "aviatrix"
#     }
#   }
# }

terraform {
  required_providers {
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
      version = "3.1.4"
    }

    aws = {
      source  = "hashicorp/aws"
    }
    
  }

}


provider "aws" {
  profile = "aviatrix"
  region  = "us-east-1"
}

provider "aviatrix" {
  controller_ip = var.controller_ip
  username      = var.username
  password      = var.password
}
