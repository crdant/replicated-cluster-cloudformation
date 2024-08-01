variable "build_directory" {
  description = "The directory containing the Python build artifact for the lambda function"
  type        = string
}

variable "role" {
  description = "The ARN of the IAM role to be assumed by the lambda function"
  type        = string
}

variable "owner" {
  description = "Owner for all resources created in AWS"
  type        = string
}

variable "api_token" {
  description = "The Replicated Vendor Portal API token"
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
