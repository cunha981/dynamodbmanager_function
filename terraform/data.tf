data "aws_caller_identity" "current" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../src/main/python/"
  output_path = "${path.root}/lambda.zip"
}

data "aws_iam_role" "lab_iam_role" {
  name = "LabRole"
}