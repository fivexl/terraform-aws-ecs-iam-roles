module "role_exec" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.6.0"

  create_role = true

  role_name         = "${var.application_name}-ecs-exec"
  role_path         = var.iam_prefix
  role_description  = "ECS execution role that will be used to launch ${var.application_name} tasks"
  role_requires_mfa = false

  custom_role_policy_arns = concat(var.exec_role_additional_policy_arns, [aws_iam_policy.ecs_execution_custom.arn])

  trusted_role_services = ["ecs-tasks.amazonaws.com"]
  trusted_role_arns     = var.exec_role_additional_trusted_role_arns

  tags = var.tags
}

module "role_task" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.6.0"

  create_role = true

  role_name         = "${var.application_name}-ecs-task"
  role_path         = var.iam_prefix
  role_description  = "ECS execution role that will be assumed by ${var.application_name} tasks"
  role_requires_mfa = false

  custom_role_policy_arns = concat(var.task_role_additional_policy_arns, [aws_iam_policy.ecs_task_custom.arn])

  trusted_role_services = ["ecs-tasks.amazonaws.com"]
  trusted_role_arns     = var.task_role_additional_trusted_role_arns

  tags = var.tags
}