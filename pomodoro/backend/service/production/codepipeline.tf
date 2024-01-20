resource "aws_codepipeline" "prod_pomodoro_backend" {
  name     = "prod-pomodoro-backend"
  role_arn = aws_iam_role.prod_pomodoro_backend_codepipeline_service_role.arn

  artifact_store {
    location = aws_s3_bucket.prod_pomodoro_backend_pipeline_artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName"           = "main"
        "ConnectionArn"        = data.aws_codestarconnections_connection.pomodoro_backend.arn
        "FullRepositoryId"     = "daichi1991/pomodoro_playlist_backend"
        "OutputArtifactFormat" = "CODE_ZIP"
      }
      name      = "Source"
      namespace = "SourceVariables"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeStarSourceConnection"
      region    = "ap-northeast-1"
      run_order = 1
      version   = "1"
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = aws_codebuild_project.prod_pomodoro_backend.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name      = "Build"
      namespace = "BuildVariables"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = "ap-northeast-1"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "ApplicationName"                = "pomodoro-backend" // NOTE: リソースはcommon参照。dataで参照できないのでコメントのみ記載。
        "AppSpecTemplateArtifact"        = "BuildArtifact"
        "AppSpecTemplatePath"            = "appspec.yml"
        "DeploymentGroupName"            = "prod-pomodoro-backend"
        "TaskDefinitionTemplateArtifact" = "BuildArtifact"
        "TaskDefinitionTemplatePath"     = "taskdef.json"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name      = "Deploy"
      owner     = "AWS"
      provider  = "CodeDeployToECS"
      region    = "ap-northeast-1"
      run_order = 1
      version   = "1"
    }
  }
}
