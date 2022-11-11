# resource "aws_s3_bucket" "lambda_model_bucket" {
#   bucket = local.bucket_name
#   tags = {
#     Name = "test bucket"
#   }
# }

# resource "aws_s3_bucket_acl" "example" {
#   bucket = aws_s3_bucket.lambda_model_bucket.id
#   acl    = "private"
# }
