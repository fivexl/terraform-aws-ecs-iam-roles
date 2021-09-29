variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "application_name" {
  type = string
}

variable "iam_prefix" {
  description = "IAM prefix to use for policies and roles. / if not specified"
  type        = string
  default     = "/"
}

variable "exec_role_additional_policy_arns" {
  description = "List of policy arns to attach to exec role"
  type        = list(string)
  default     = []
}

variable "exec_role_additional_trusted_role_arns" {
  description = "ARNs of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
}

variable "task_role_additional_policy_arns" {
  description = "List of policy arns to attach to task role"
  type        = list(string)
  default     = []
}

variable "task_role_additional_trusted_role_arns" {
  description = "ARNs of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
}

# CloudWatch

variable "cloudwatch_account_id" {
  description = "Account id to where to allow writing of CloudWatch logs. Will use current account id if not provided"
  type        = string
  default     = null
}

variable "cloudwatch_regions" {
  description = "Regions from to where to allow writing of CloudWatch logs. Will use current region if not provided"
  type        = list(string)
  default     = []
}

# AppMesh

variable "appmesh_account_id" {
  description = "Account id from where to allow streaming of agregated resources. Will use current account id if not provided"
  type        = string
  default     = null
}

variable "appmesh_regions" {
  description = "Regions from where to allow streaming of agregated resources. Will use current region if not provided"
  type        = list(string)
  default     = []
}

# Secrets manager

variable "secrets_manager_account_id" {
  description = "Account id to where to allow reading of secrets. Will use current account id if not provided"
  type        = string
  default     = null
}

variable "secrets_manager_regions" {
  description = "Regions from to where to allow reading of secrets. Will use current region if not provided"
  type        = list(string)
  default     = []
}

variable "secrets_manager_prefix" {
  description = "Secrets manager prefix for the app. will use /applications if not provided"
  type        = string
  default     = "/applications"
}

# SSM

variable "ssm_account_id" {
  description = "Account id from where to allow reading of SSM parameters. Will use current account id if not provided"
  type        = string
  default     = null
}

variable "ssm_regions" {
  description = "Regions from where to allow reading of SSM parameters. Will use current region if not provided"
  type        = list(string)
  default     = []
}

variable "ssm_parameter_prefix" {
  description = "SSM parameter prefix for the app"
  type        = string
  default     = "/applications"
}

# ECR

variable "ecr_arns" {
   description = "List of ARNs for ECR repos from where to allow pulling of images. If not set will use value of application_name as ECR repo name in the current account/region"
  type        = list(string)
  default     = null 
}