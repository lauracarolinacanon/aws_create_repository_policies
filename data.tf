data "aws_caller_identity" "current" {
  provider = aws
}

output "aws_account_id" {
  description = "AWS Account ID used by Terraform"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_user_arn" {
  description = "ARN of the identity Terraform is using"
  value       = data.aws_caller_identity.current.arn
}

output "aws_user_id" {
  description = "User or role ID"
  value       = data.aws_caller_identity.current.user_id
}