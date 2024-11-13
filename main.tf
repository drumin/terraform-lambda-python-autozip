provider "aws" {
  region = var.aws_region
}

# Run pip install requirements in case the requirements document changes
resource "null_resource" "pip_install" {
  triggers = {
    shell_hash = sha256(file("${var.file_storage}/requirements.txt"))
  }

  provisioner "local-exec" {
    command = "python3 -m pip install -r requirements.txt -t ${var.file_storage}/layer/python --break-system-packages"
  }
}

# Zip the python dependencies into layer.zip
data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${var.file_storage}/layer"
  output_path = "${var.file_storage}/layer.zip"
  depends_on  = [null_resource.pip_install]
}

# Zip the python code into code.zip
data "archive_file" "code" {
  type        = "zip"
  source_dir  = "${var.file_storage}/code"
  output_path = "${var.file_storage}/code.zip"
}

# Trigger Lambda based on schedule
resource "aws_cloudwatch_event_rule" "triggerLambdaFunction" {
  name                = var.event_rule_name
  schedule_expression = var.schedule_expression # Use variable for schedule expression
}

# CloudWatch Event Target (trigger Lambda)
resource "aws_cloudwatch_event_target" "trigger_lambda_on_schedule" {
  rule      = aws_cloudwatch_event_rule.triggerLambdaFunction.name
  target_id = var.lambda_target_id 
  arn       = aws_lambda_function.lambda_function.arn
}

# Lambda function definition 
resource "aws_lambda_function" "lambda_function" {
  function_name    = var.lambda_function_name 
  handler          = var.lambda_handler 
  runtime          = var.lambda_runtime 
  filename         = data.archive_file.code.output_path 
  source_code_hash = data.archive_file.code.output_base64sha256 
  role             = aws_iam_role.lambda_role.arn 
  layers           = [aws_lambda_layer_version.layer.arn] 
  timeout          = var.lambda_timeout 
}

# Lambda Layer for Python dependencies 
resource "aws_lambda_layer_version" "layer" {
  layer_name               = var.layer_name 
  filename                 = data.archive_file.layer.output_path 
  source_code_hash         = data.archive_file.layer.output_base64sha256 
  compatible_runtimes      = [var.lambda_runtime] 
}

# Allow CloudWatch Events to invoke Lambda function 
resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
  action           = "lambda:InvokeFunction"
  function_name    = aws_lambda_function.lambda_function.function_name 
  principal        = "events.amazonaws.com"
  source_arn       = aws_cloudwatch_event_rule.triggerLambdaFunction.arn 
}
