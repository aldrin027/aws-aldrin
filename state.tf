terraform {
  backend "s3" {
    bucket = "aws-cicd-aldrin"
    encrypt = true
    key = "terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}