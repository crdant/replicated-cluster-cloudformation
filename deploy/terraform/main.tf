resource "aws_secretsmanager_secret" "api_token" {
  name        = "${var.application}-replicated-vendor-api-token"
  description = "API token the Replicated Vendor Portal"
}

resource "aws_secretsmanager_secret_version" "api_token" {
  secret_id     = aws_secretsmanager_secret.api_token.id
  secret_string = var.api_token
}

module "create_license_us_west_2" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token_arn = aws_secretsmanager_secret.api_token.arn

  providers = {
    aws = aws.us-west-2
  }
}
