# START Pipeline Roles
resource "aws_iam_role" "tf-cicd-pipeline-role" {
  name = "tf-cicd-pipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
  statement {
    sid = ""
    actions = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect = "Allow"
  }
  statement {
    sid = ""
    actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
  name = "tf-cicd-pipeline-policy"
  path = "/"
  description = "Pipeline policy"
  policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
  policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
  role = aws_iam_role.tf-cicd-pipeline-role.id
}
# END Pipeline Roles


# START Codebuild Roles

resource "aws_iam_role" "tf-cicd-codebuild-role" {
  name = "tf-cicd-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf-cicd-codebuild-policies" {
  statement {
    sid = ""
    actions = ["logs:*", "codebuild:*", "secretsmanager:*", "iam:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "tf-cicd-codebuild-policy" {
  name = "tf-cicd-codebuild-policy"
  path = "/"
  description = "Codebuild policy"
  policy = data.aws_iam_policy_document.tf-cicd-codebuild-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
  policy_arn = aws_iam_policy.tf-cicd-codebuild-policy.arn
  role = aws_iam_role.tf-cicd-codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  role = aws_iam_role.tf-cicd-codebuild-role.id
}

# END Codebuild Roles