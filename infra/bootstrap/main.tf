# Bootstrap root: owns only the bucket that stores Terraform state for every
# other root. Its own state stays local (gitignored) so the state bucket is
# never managed by the state it stores.

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

variable "aws_profile" {
  type    = string
  default = "edgar"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# S3 bucket names are global; the random suffix avoids collisions without
# leaking the account id into a public repo.
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "edgar-lakehouse-tfstate-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    id     = "abort-incomplete-multipart"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

output "state_bucket_name" {
  value       = aws_s3_bucket.tfstate.bucket
  description = "Backend bucket for all other Terraform roots"
}
