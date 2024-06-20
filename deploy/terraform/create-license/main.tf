# topic-backed custom resource
resource "aws_sns_topic" "create_license" {
  name = "create_${var.application}_license"
}

resource "aws_sns_topic_subscription" "create_liceense" {
  topic_arn = aws_sns_topic.create_license.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.create_license.arn
}

resource "aws_lambda_function" "create_license" {
  function_name = "create-${var.application}-license"
  architectures = ["arm64"]

  handler       = "main.handler"  
  role          = var.role
  runtime       = "python3.11"

  filename         = "${var.build_directory}/create-license.zip"
  source_code_hash = filebase64sha256("${var.build_directory}/create-license.zip")
  
  timeout = 6

  environment {
    variables = {
      SECRET_ARN = var.api_token_arn
      LICENSE_BUCKET_NAME = var.license_bucket_name
    }
  }
}

resource "aws_lambda_permission" "lambda_license_topic" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_license.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.create_license.arn
}

