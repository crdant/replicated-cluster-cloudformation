locals {
  user_data = templatefile("${path.module}/templates/user-data.tftpl",
                             {
                               application = var.application,
                               install_dir = "/opt/${var.application}",
                              }
                          )
  cloudformation_template = templatefile("${path.module}/templates/slackernews_cloudformation.tftpl",
                                {
                                  license_topic_ap_northeast_1 = module.create_license_ap_northeast_1.topic_arn
                                  license_topic_ap_northeast_2 = module.create_license_ap_northeast_2.topic_arn
                                  license_topic_ap_northeast_3 = module.create_license_ap_northeast_3.topic_arn
                                  license_topic_ap_south_1 = module.create_license_ap_south_1.topic_arn
                                  license_topic_ap_southeast_1 = module.create_license_ap_southeast_1.topic_arn
                                  license_topic_ap_southeast_2 = module.create_license_ap_southeast_2.topic_arn
                                  license_topic_ca_central_1 = module.create_license_ca_central_1.topic_arn
                                  license_topic_eu_central_1 = module.create_license_eu_central_1.topic_arn
                                  license_topic_eu_north_1 = module.create_license_eu_north_1.topic_arn
                                  license_topic_eu_west_1 = module.create_license_eu_west_1.topic_arn
                                  license_topic_eu_west_2 = module.create_license_eu_west_2.topic_arn
                                  license_topic_eu_west_3 = module.create_license_eu_west_3.topic_arn
                                  license_topic_sa_east_1 = module.create_license_sa_east_1.topic_arn
                                  license_topic_us_east_1 = module.create_license_us_east_1.topic_arn
                                  license_topic_us_east_2 = module.create_license_us_east_2.topic_arn
                                  license_topic_us_west_1 = module.create_license_us_west_1.topic_arn
                                  license_topic_us_west_2 = module.create_license_us_west_2.topic_arn
                                  user_data = indent(14, local.user_data)
                                  app_id = var.app_id
                                  application = var.application,
                                }
                             )
}

resource "random_pet" "bucket_suffix" {
  length = 2
}

data "aws_iam_policy_document" "stack_policy" {
  statement {
    effect = "Allow"
    actions   = [ "lambda:InvokeFunction" ]
    resources = [ module.create_license_us_west_2.function_arn ]
  }

  statement {
    effect = "Allow"
    actions   = [
                  "ec2:RunInstances",
                  "ec2:TerminateInstances",
                  "ec2:DescribeInstances",
                  "ec2:DescribeInstanceStatus",
                  "ec2:CreateSecurityGroup",
                  "ec2:DeleteSecurityGroup",
                  "ec2:AuthorizeSecurityGroupIngress",
                  "ec2:RevokeSecurityGroupIngress",
                  "ec2:DescribeSecurityGroups",
                  "ec2:CreateVpc",
                  "ec2:DeleteVpc",
                  "ec2:ModifyVpcAttribute",
                  "ec2:DescribeVpcs",
                  "ec2:CreateSubnet",
                  "ec2:DeleteSubnet",
                  "ec2:ModifySubnetAttribute",
                  "ec2:DescribeSubnets",
                  "ec2:CreateInternetGateway",
                  "ec2:DeleteInternetGateway",
                  "ec2:AttachInternetGateway",
                  "ec2:DetachInternetGateway",
                  "ec2:DescribeInternetGateways",
                  "ec2:CreateRoute",
                  "ec2:CreateRouteTable",
                  "ec2:DeleteRoute",
                  "ec2:DeleteRouteTable",
                  "ec2:AssociateRouteTable",
                  "ec2:DisassociateRouteTable",
                  "ec2:DescribeRouteTables",
                  "ec2:CreateSecurityGroup",
                  "ec2:DeleteSecurityGroup",
                  "ec2:AuthorizeSecurityGroupIngress",
                  "ec2:RevokeSecurityGroupIngress",
                  "ec2:DescribeSecurityGroups"
                ]
    resources = [ "*" ]
  }
}

resource "aws_iam_policy" "stack_policy" {
  name        = "create-${var.application}-cluster"
  description = "License creation stack policy"

  policy = data.aws_iam_policy_document.stack_policy.json
}

resource "aws_iam_role" "stack_role" {
  name = "create-${var.application}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudformation.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "stack_role" {
  role       = aws_iam_role.stack_role.name
  policy_arn = aws_iam_policy.stack_policy.arn
}

resource "aws_s3_bucket" "template_bucket" {
  bucket = "slackernews-cf-${random_pet.bucket_suffix.id}"
}

resource "aws_s3_bucket_public_access_block" "template_bucket" {
  bucket = aws_s3_bucket.template_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "template_bucket" {
  bucket = aws_s3_bucket.template_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "cloudformation_template" {
  bucket = aws_s3_bucket.template_bucket.id
  key    = "slackernews_cloudformation.yaml"
  acl    = "public-read"

  content_type = "text/yaml"
  content      = local.cloudformation_template

  etag = md5(local.cloudformation_template)
}
