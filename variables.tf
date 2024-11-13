variable "aws_region" {
  description   = "The AWS region to deploy resources."
  type          = string
}

variable "lambda_function_name" {
  description   = "The name of the Lambda function."
  type          = string
}

variable "lambda_handler" {
  description   = "The handler for the Lambda function."
  type          = string
}

variable "lambda_runtime" {
  description   = "The runtime environment for the Lambda function."
  type          = string
}

variable "lambda_timeout" {
  description   = "The timeout setting for the Lambda function."
  type          = string
}

variable "schedule_expression" {
  description   = "Schedule expression to trigger Lambda function."
  type          = string
}

variable "file_storage" {
  description   = "Storage location of the python project."
  type          = string
}

variable "lambda_role_name" {
  description   = "(Optional) Name of the lambda permission role."
  type          = string
  default       = "lambda_role"
}

variable "lambda_execution_policy_name" {
  description   = "(Optional) Name of the lambda permission policy for Lambda basic execution."
  type          = string
  default       = "AWSLambdaBasicExecutionRole"
}

variable "secrets_manager_policy_arn" {
  description   = "(Optional) ARN of Secrets Manager policy."
  type          = string
  default       = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

variable "event_rule_name" {
  description   = "(Optional) Name of CloudWatch Event Rule."
  type          = string
  default       = "triggerLambdaFunction"
}

variable "lambda_target_id" {
  description   = "(Optional) CloudWatch Target ID."
  type          = string
  default       = "lambda"
}

variable "layer_name" {
  description   = "(Optional) Name of the lambda layer."
  type          = string
  default       = "python-dependencies-layer"
}

variable "secrets_stored" {
  description   = "Set to true if your code stores secrets and need to access secrets manager. Else set to false."
  type          = bool
}
