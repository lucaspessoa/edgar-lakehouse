# Consumed by later deliveries (D08 grants Databricks access per layer).

output "layer_bucket_names" {
  value       = { for k, b in aws_s3_bucket.layer : k => b.bucket }
  description = "Layer name to bucket name"
}

output "layer_bucket_arns" {
  value       = { for k, b in aws_s3_bucket.layer : k => b.arn }
  description = "Layer name to bucket ARN"
}
