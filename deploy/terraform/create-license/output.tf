output "function_arn" {
  value = aws_lambda_function.create_license.arn
}

output "topic_arn" {
  value = aws_sns_topic.create_license.arn
}

output "api_token_arn" {
  value = aws_secretsmanager_secret.api_token.arn
}
