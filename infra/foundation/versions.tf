terraform {
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "s3" {
    bucket       = "edgar-lakehouse-tfstate-bd22c07b"
    key          = "foundation/terraform.tfstate"
    region       = "us-east-1"
    profile      = "edgar"
    use_lockfile = true
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region

  default_tags {
    tags = {
      project    = "edgar-lakehouse"
      managed_by = "terraform"
      env        = "dev"
    }
  }
}
