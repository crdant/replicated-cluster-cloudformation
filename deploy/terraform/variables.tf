variable "build_directory" {
  description = "The directory containing the Python build artifact for the lambda function"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"  # You can set a default value or leave it empty
}

variable "owner" {
  description = "Owner for all resources created in AWS"
  type        = string
}

variable "api_token" {
  description = "The Replicated Vendor Portal API token to be stored in AWS Secrets Manager"
  type        = string
}

variable "application" {
  description = "The slug for your application on the Replicated vendor portal"
  type        = string
}

variable "app_id" {
  description = "The ID of your application on the Replicated vendor portal"
  type        = string
}
