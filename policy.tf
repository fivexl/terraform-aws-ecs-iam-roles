resource "aws_iam_policy" "ecs_task_custom" {
  name_prefix = "${var.application_name}-ecs-task"
  description = "ECS execution policy that will be assumed through task role by ${var.application_name} tasks"
  path        = var.iam_prefix
  policy      = data.aws_iam_policy_document.task.json
}

resource "aws_iam_policy" "ecs_execution_custom" {
  name_prefix = "${var.application_name}-ecs-exec"
  description = "ECS execution policy that will be used to launch ${var.application_name} tasks"
  path        = var.iam_prefix
  policy      = data.aws_iam_policy_document.exec.json
}

data "aws_iam_policy_document" "task" {
  source_policy_documents = [
    data.aws_iam_policy_document.cloudwatch.json,
    data.aws_iam_policy_document.secrets.json,
    data.aws_iam_policy_document.ssm.json,
    data.aws_iam_policy_document.ssm_agent.json,
    data.aws_iam_policy_document.appmesh.json,
    data.aws_iam_policy_document.xray.json
  ]
}

data "aws_iam_policy_document" "exec" {
  source_policy_documents = [
    data.aws_iam_policy_document.ecr.json,
    data.aws_iam_policy_document.cloudwatch.json,
    data.aws_iam_policy_document.secrets.json,
    data.aws_iam_policy_document.ssm.json
  ]
}

data "aws_iam_policy_document" "ecr" {
  statement {
    sid    = "ECRToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "ECR"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
    resources = local.ecr_arns
  }
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = concat(
      [for region in local.cloudwatch_regions : "arn:aws:logs:${region}:${local.cloudwatch_account_id}:log-group:/ecs/*/${var.application_name}*"],
      [for region in local.cloudwatch_regions : "arn:aws:logs:${region}:${local.cloudwatch_account_id}:log-group:/ecs/*/${var.application_name}*:log-stream:*"],
    )
  }
}

data "aws_iam_policy_document" "secrets" {
  statement {
    sid    = "Secrets"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [for region in local.secrets_manager_regions : "arn:aws:secretsmanager:${region}:${local.secrets_manager_account_id}:secret:${var.secrets_manager_prefix}/${var.application_name}*"]
  }
}

data "aws_iam_policy_document" "ssm" {
  statement {
    sid    = "SSM"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = concat(
      [for region in local.ssm_regions : "arn:aws:ssm:${region}:${local.ssm_account_id}:parameter${var.ssm_parameter_prefix}/${var.application_name}/*"],
      [for region in local.ssm_regions : "arn:aws:ssm:${region}:${local.ssm_account_id}:parameter${var.ssm_parameter_prefix}/${var.application_name}"]
    )
  }
}

data "aws_iam_policy_document" "appmesh" {

  statement {
    sid    = "AppMesh"
    effect = "Allow"
    actions = [
      "appmesh:StreamAggregatedResources"
    ]
    resources = concat(
      [for region in local.appmesh_regions : "arn:aws:appmesh:${region}:${local.appmesh_account_id}:mesh/*/virtualGateway/${var.application_name}*"],
      [for region in local.appmesh_regions : "arn:aws:appmesh:${region}:${local.appmesh_account_id}:mesh/*/virtualNode/${var.application_name}*"],
    )
  }
}

data "aws_iam_policy_document" "xray" {

  statement {
    sid    = "XRay"
    effect = "Allow"
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ssm_agent" {
  statement {
    sid    = "SSMAgent"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "logs:DescribeLogGroups"
    ]
    resources = [
      "*"
    ]
  }
}