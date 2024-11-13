module "lambda_function" {
  source                    = ".."
  aws_region                = "us-east-1"
  lambda_function_name      = "example_lambda_function"
  lambda_handler            = "lambda.main"
  lambda_runtime            = "python3.12"
  lambda_timeout            = "300"
  schedule_expression       = "cron(00 00 * * ? *)"
  file_storage              = path.module
  secrets_stored            = false
}