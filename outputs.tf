output "ecs_execution_role_arn" {
  value = module.role_exec.iam_role_arn
}

output "ecs_task_role_arn" {
  value = module.role_task.iam_role_arn
}