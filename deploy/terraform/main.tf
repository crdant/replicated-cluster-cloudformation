module "create_license_ap_northeast_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.ap-northeast-1
  }
}

module "create_license_ap_northeast_2" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "create_license_ap_northeast_3" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.ap-northeast-3
  }
}

module "create_license_ap_south_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.ap-south-1
  }
}

module "create_license_ap_southeast_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.ap-southeast-1
  }
}

module "create_license_ap_southeast_2" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.ap-southeast-2
  }
}

module "create_license_ca_central_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.ca-central-1
  }
}

module "create_license_eu_central_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.eu-central-1
  }
}

module "create_license_eu_north_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.eu-north-1
  }
}

module "create_license_eu_west_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.eu-west-1
  }
}

module "create_license_eu_west_2" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.eu-west-2
  }
}

module "create_license_eu_west_3" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.eu-west-3
  }
}

module "create_license_sa_east_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.sa-east-1
  }
}

module "create_license_us_east_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.us-east-1
  }
}

module "create_license_us_east_2" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.us-east-2
  }
}

module "create_license_us_west_1" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.us-west-1
  }
}

module "create_license_us_west_2" {
  source = "./create-license"

  application = var.application
  app_id = var.app_id

  owner = var.owner
  build_directory = var.build_directory
  license_bucket_name = aws_s3_bucket.licenses.bucket
  role = aws_iam_role.license_lambda_exec_role.arn
  api_token = var.api_token

  providers = {
    aws = aws.us-west-2
  }
}
