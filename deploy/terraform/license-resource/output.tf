output "template_url" {
  value = "https://${aws_s3_bucket.template_bucket.bucket}.s3.${var.aws_region}.amazonaws.com/${aws_s3_object.cloudformation_template.key}"
}

output "stack_role_arn" {
  value = aws_iam_role.stack_role.arn
}

output "marketplace_ami_ingestion_role_arn" {
  value = aws_iam_role.marketplace_ami_ingestion.arn
}
