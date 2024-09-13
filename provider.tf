terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

provider "github" {
  owner = "SeattleSlough"
  token = "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"
}