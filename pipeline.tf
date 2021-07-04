resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan"
  description   = "Plan stage for Terraform"
  service_role  = aws_iam_role.tf-cicd-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.1.0-alpha20210630"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
      credential = var.dockerhub_creds
      credential_provider = "SECRETS_MANAGER"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")
  }
}

resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply"
  description   = "Apply buildspec for Terraform"
  service_role  = aws_iam_role.tf-cicd-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.1.0-alpha20210630"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
      credential = var.dockerhub_creds
      credential_provider = "SECRETS_MANAGER"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")
  }
}

resource "aws_codepipeline" "cicd_pipeline" {
  name     = "tf-cicd"
  role_arn = aws_iam_role.tf-cicd-pipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.aldrin-pipeline-artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeStarSourceConnection"
      version = "1"
      output_artifacts = ["tf-code"]

      configuration = {
        FullRepositoryId = "aldrin027/aws-aldrin"
        BranchName       = "main"
        ConnectionArn    = var.codestar_connector_creds
        OutputArtifactFormat = "CODE_ZIP"

      }
    }
  }

  stage {
    name = "Plan"

    action {
      name = "Build"
      category = "Build"
      provider = "CodeBuild"
      owner = "AWS"
      version = "1"
      input_artifacts = ["tf-code"]

      configuration = {
        ProjectName = "tf-cicd-plan"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Build"
      category = "Build"
      provider = "CodeBuild"
      owner = "AWS"
      version = "1"
      input_artifacts = ["tf-code"]

      configuration = {
        ProjectName = "tf-cicd-apply"
      }
    }
  }

}
