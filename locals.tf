locals {
  ecr_arns = length(var.ecr_arns) != 0 ? var.ecr_arns : ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/${var.application_name}"]

  cloudwatch_regions    = length(var.cloudwatch_regions) != 0 ? var.cloudwatch_regions : [data.aws_region.current.name]
  cloudwatch_account_id = var.cloudwatch_account_id != null ? var.cloudwatch_account_id : data.aws_caller_identity.current.account_id

  secrets_manager_regions    = length(var.secrets_manager_regions) != 0 ? var.secrets_manager_regions : [data.aws_region.current.name]
  secrets_manager_account_id = var.secrets_manager_account_id != null ? var.secrets_manager_account_id : data.aws_caller_identity.current.account_id

  ssm_regions    = length(var.ssm_regions) != 0 ? var.ssm_regions : [data.aws_region.current.name]
  ssm_account_id = var.ssm_account_id != null ? var.ssm_account_id : data.aws_caller_identity.current.account_id

  appmesh_regions    = length(var.appmesh_regions) != 0 ? var.appmesh_regions : [data.aws_region.current.name]
  appmesh_account_id = var.appmesh_account_id != null ? var.appmesh_account_id : data.aws_caller_identity.current.account_id
}