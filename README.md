# Terraform Code to Deploy Python Code to Lambda

This Terraform module helps create a Lambda function which runs on Python and is triggered by a cronjob. This code also allows you to set to access secrets from the AWS Secrets Manager.
The code will detect whenever there is any change in the code or requirements file and update the changes.

## Inputs

|Name|Description|Mandatory|
|----|----|----|
|aws_region|The AWS region to deploy resources.|True|
|file_storage|Storage location of the python project.|True|
|lambda_function_name|The name of the Lambda function.|True|
|lambda_handler|The handler for the Lambda function.|True|
|lambda_runtime|The runtime environment for the Lambda function.|True|
|lambda_timeout|The timeout setting for the Lambda function.|True|
|schedule_expression|Schedule expression to trigger Lambda function.|True|
|secrets_stored|Set to true if your code stores secrets and need to access secrets manager. Else set to false.|True|
|event_rule_name|Name of CloudWatch Event Rule.|False|
|lambda_role_name|Name of the lambda permission role.|False|
|lambda_execution_policy_name|Name of the lambda permission policy for Lambda basic execution.|False|
|lambda_target_id|CloudWatch Target ID.|False|
|layer_name|Name of the lambda layer.|False|
|secrets_manager_policy_arn|ARN of Secrets Manager policy.|False|

## Commands to run
```
# Initialize Terraform
terraform init

# View the Deployment Plan
terraform plan

# Apply the Deployment Plan
terraform apply
```
