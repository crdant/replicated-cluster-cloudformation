resource "aws_iam_policy" "create_license_secrets_manager" {
  name   = "create-${var.application}-license-secrets_manager"
  policy = data.aws_iam_policy_document.create_license_secrets_manager.json
}

data "aws_iam_policy_document" "create_license_secrets_manager" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [
      module.create_license_ap_northeast_1.api_token_arn,
      module.create_license_ap_northeast_2.api_token_arn,
      module.create_license_ap_northeast_3.api_token_arn,
      module.create_license_ap_south_1.api_token_arn,
      module.create_license_ap_southeast_1.api_token_arn,
      module.create_license_ap_southeast_2.api_token_arn,
      module.create_license_ca_central_1.api_token_arn,
      module.create_license_eu_central_1.api_token_arn,
      module.create_license_eu_north_1.api_token_arn,
      module.create_license_eu_west_1.api_token_arn,
      module.create_license_eu_west_2.api_token_arn,
      module.create_license_eu_west_3.api_token_arn,
      module.create_license_sa_east_1.api_token_arn,
      module.create_license_us_east_1.api_token_arn,
      module.create_license_us_east_2.api_token_arn,
      module.create_license_us_west_1.api_token_arn,
      module.create_license_us_west_2.api_token_arn,
    ]
  }
}

data "aws_iam_policy" "license_lambda_exec_policy" {
  name = "AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "create_license_secrets_manager" {
  role       = aws_iam_role.license_lambda_exec_role.id
  policy_arn = aws_iam_policy.create_license_secrets_manager.arn
}

resource "aws_iam_role_policy_attachment" "license_lambda_exec_policy" {
  role       = aws_iam_role.license_lambda_exec_role.id
  policy_arn = data.aws_iam_policy.license_lambda_exec_policy.arn
}

resource "aws_iam_role" "license_lambda_exec_role" {
  name = "${var.application}-license-lambda-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

