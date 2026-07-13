# One bucket per lakehouse layer. Separate buckets (rather than prefixes in
# one) keep IAM grants, lifecycle policies and cost reporting per-layer:
# Databricks later gets bronze-and-up, never landing.
#
# Versioning stays off on data buckets: landing is replayable from the source
# APIs, and Bronze onward Delta Lake provides time travel. The state bucket
# (infra/bootstrap) is the only versioned one.

locals {
  # expire_days applies only where raw data is disposable by design.
  layers = {
    landing = { expire_days = 90 }
    bronze  = { expire_days = null }
    silver  = { expire_days = null }
    gold    = { expire_days = null }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "layer" {
  for_each = local.layers

  bucket = "edgar-lakehouse-${each.key}-${random_id.suffix.hex}"

  tags = {
    layer = each.key
  }
}

resource "aws_s3_bucket_public_access_block" "layer" {
  for_each = aws_s3_bucket.layer

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "layer" {
  for_each = aws_s3_bucket.layer

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "layer" {
  for_each = aws_s3_bucket.layer

  bucket = each.value.id

  rule {
    id     = "abort-incomplete-multipart"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  dynamic "rule" {
    for_each = local.layers[each.key].expire_days != null ? [local.layers[each.key].expire_days] : []

    content {
      id     = "expire-raw-objects"
      status = "Enabled"

      filter {}

      expiration {
        days = rule.value
      }
    }
  }
}
