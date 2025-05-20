terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "jakucja_personal"

    workspaces {
      name = "zerocarb-terraform-state"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}
