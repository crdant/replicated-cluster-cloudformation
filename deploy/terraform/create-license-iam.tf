resource "aws_sns_topic_policy" "create_license_policy" {
  arn    = aws_sns_topic.create_license.arn
  policy = data.aws_iam_policy_document.create_license_policy.json
}

data "aws_iam_policy_document" "create_license_policy" {
  statement {
    actions = [
      "SNS:Publish"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.create_license.arn
    ]
  }
}

resource "aws_iam_policy" "create_license_secrets_manager" {
  name   = "create-${var.application}-license-secrets_manager"
  policy = data.aws_iam_policy_document.create_license_secrets_manager.json
}

data "aws_iam_policy_document" "create_license_secrets_manager" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.api_token.arn]
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

