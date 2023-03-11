terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
  required_version = "~> 1.3.4"

  backend "s3" {
    bucket = "michael.coburn-terraform"
    key    = "pmm.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region = "us-west-1"
  default_tags {
    tags = {
      Terraform       = "Yes"
      iit-billing-tag = "michael.coburn@percona.com"
    }
  }
}

provider "azurerm" {
  alias = "demo"
  features {}
}
