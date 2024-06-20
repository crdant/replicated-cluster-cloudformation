resource "aws_iam_role" "marketplace_ami_ingestion" {
  name = "${var.application}-marketplace-ami-ingestion"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = ""
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "assets.marketplace.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "marketplace_ami_policy_attachment" {
  role       = aws_iam_role.marketplace_ami_ingestion.name
  policy_arn = "arn:aws:iam::aws:policy/AWSMarketplaceAmiIngestion"
}

