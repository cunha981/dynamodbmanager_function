terraform {
  backend "s3" {
    bucket = "general-tf-state-bucket"
    key    = "serverless-terraform.tfstate"
    region = "us-east-1"
  }
}