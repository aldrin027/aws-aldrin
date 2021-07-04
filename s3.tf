resource "aws_s3_bucket" "aldrin-pipeline-artifacts" {
  bucket = "aldrin-pipeline-artifacts"
  acl = "private"
}