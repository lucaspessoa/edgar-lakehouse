variable "aws_profile" {
  type    = string
  default = "edgar"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Supplied via terraform.tfvars (gitignored): alert e-mails stay out of the
# public repo.
variable "budget_email" {
  type = string
}
