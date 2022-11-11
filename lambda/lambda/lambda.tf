resource "null_resource" "ecr_image" {
  triggers = {
    ts_file_1   = filemd5("../app/lambdas/common.ts")
    ts_file_2   = filemd5("../app/lambdas/hello.ts")
    json_file   = filemd5("../app/package.json")
    yarn_file   = filemd5("../app/yarn.lock")
    docker_file = filemd5("../app/Dockerfile")
  }
  provisioner "local-exec" {
    command = <<EOF
           aws ecr get-login-password --region ${local.region} | docker login --username hprince --password-stdin ${local.account_id}.dkr.ecr.${local.region}.amazonaws.com
           docker ${aws_ecr_repository.lambda_model_repository.name}:${local.ecr_image_tag} .
           docker push ${aws_ecr_repository.lambda_model_repository.name}:${local.ecr_image_tag}
       EOF
  }
}
