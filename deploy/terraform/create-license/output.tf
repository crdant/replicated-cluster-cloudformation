output "function_arn" {
  value = aws_lambda_function.create_license.arn
}

output "topic_arn" {
  value = aws_sns_topic.create_license.arn
}
