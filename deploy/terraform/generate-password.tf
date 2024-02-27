resource "aws_lambda_function" "generate_password" {
  function_name = "generate-${var.application}-password"
  architectures = ["arm64"]

  handler       = "main.handler"  # Assuming your Python file is named lambda_function.py
  role          = aws_iam_role.password_lambda_exec_role.arn
  runtime       = "python3.11"

  filename         = "${var.build_directory}/generate-password.zip"
  source_code_hash = filebase64sha256("${var.build_directory}/generate-password.zip")
}

resource "aws_iam_policy" "generate_password_secrets_manager" {
  name   = "generate-${var.application}-password-secrets-manager"
  policy = data.aws_iam_policy_document.generate_password_secrets_manager.json
}

data "aws_iam_policy_document" "generate_password_secrets_manager" {
  statement {
    actions = [
      "secretsmanager:CreateSecret"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:DeleteSecret"
    ]
    resources = [
      "arn:aws:secretsmanager:*:*:secret:*-admin-console-*"
    ]
  }
}

data "aws_iam_policy" "password_lambda_exec_policy" {
  name = "AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "generate_password_secrets_manager" {
  role       = aws_iam_role.password_lambda_exec_role.id
  policy_arn = aws_iam_policy.generate_password_secrets_manager.arn
}

resource "aws_iam_role_policy_attachment" "password_lambda_exec_policy" {
  role       = aws_iam_role.password_lambda_exec_role.id
  policy_arn = data.aws_iam_policy.password_lambda_exec_policy.arn
}

resource "aws_iam_role" "password_lambda_exec_role" {
  name = "${var.application}-password-lambda-exec"

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

