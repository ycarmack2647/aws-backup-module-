# Data source to get the AWS account ID
data "aws_caller_identity" "current" {}

# Data source to get all EC2 instances
data "aws_instances" "all_instances" {
  filter {
    name   = "instance-state-name"
    values = ["running"] # Get only running instances
  }
}

# Define a variable for the AWS region
variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

# Construct ARNs for all EC2 instances
locals {
  ec2_instance_arns = [for id in data.aws_instances.all_instances.ids : "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/${id}"]
}

module "ec2-backup" {
  source                = "../aws-backup-module"
  kms_alias_name        = "alias/test-key-backup-vault-key"
  backup_vault_name     = "shon-backup-vault"
  backup_plan_name      = "shon-backup-plan"
  backup_rule_name      = "shon-backup-rule"
  backup_schedule       = "cron(26 3 * * ? *)"
  backup_start_window   = 60
  cold_storage_after    = 30
  delete_after          = 365
  backup_selection_name = "shon-backup-selection"
  backup_resources      = local.ec2_instance_arns
  backup_role_name      = "shon-backup-role"
}
