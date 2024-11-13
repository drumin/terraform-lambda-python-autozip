# Store AWS account_id and region in local variables
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# Decalre the Lambda trust policy
data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions    = ["sts:AssumeRole"]
    effect     = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Attach the Role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
}

# Declare the Lambda basic execution policy
data "aws_iam_policy_document" "AWSLambdaBasicExecutionPolicy" {
  statement {
    effect     = "Allow"
    actions    = ["logs:CreateLogGroup"]
    resources  = ["arn:aws:logs:${data.aws_region.current.name}:${local.account_id}:*"]
  }
  
  statement {
    effect     = "Allow"
    actions    = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources  = ["arn:aws:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/lambda/*:*"]
  }
}

# Create IAM policy for Lambda execution
resource "aws_iam_policy" "AWSLambdaBasicExecutionPolicy" {
  name   = var.lambda_execution_policy_name
  policy = data.aws_iam_policy_document.AWSLambdaBasicExecutionPolicy.json
}

# Attach Lambda execution policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionPolicy.arn
}

# Attach Secrets Manager read/write policy to IAM role (optional)
resource "aws_iam_role_policy_attachment" "secrets_manager_policy_attach" {
  count      = var.secrets_stored ? 1:0 
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.secrets_manager_policy_arn
}
