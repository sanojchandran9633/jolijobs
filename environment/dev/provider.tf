terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # cloud {
  #   organization = "jolijobs"
  #   workspaces {
  #     name = "JJ_Dev"
  #   }
  # }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "Dev"
      ManagedBy   = "terraform"
    }
  }
}
