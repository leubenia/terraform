variable "aws_profile" {
  type    = string
  default = "lambda-model"
}

# constant settings
locals {
  image_name    = "lambda-test"
  image_version = "latest"

  bucket_name = "lambda-test-bucket"

  lambda_function_name = "lambda-test-function"

  api_name            = "lambda-test-api"
  api_path            = "predict"
  account_id          = data.aws_caller_identity.current_identity.account_id
  prefix              = "lambda-cycles-final"
  ecr_repository_name = "${local.prefix}-image-repo"
  region              = "ap-northeast-2"
  ecr_image_tag       = "latest"
}
