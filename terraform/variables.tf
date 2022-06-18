variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region where to provision"
}

variable "lambda_name" {
  type        = string
  default     = "dynamodbmanager_function"
  description = "Lambda function name"
}

variable "api_stage_name" {
  type        = string
  default     = "dev"
  description = "API Gateway Stage"
}

