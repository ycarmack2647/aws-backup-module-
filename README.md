# AWS Backup Terraform Module

This Terraform module sets up an AWS Backup plan with encryption using a KMS key, an IAM role for the backup service, a backup vault, and assigns resources to the backup plan.

## Usage

Below is an example of how to call this module, this example will backup all running EC2 instances in the backup vault:

```hcl
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
  kms_alias_name        = "alias/test-backup-vault-key"
  backup_vault_name     = "test-backup-vault"
  backup_plan_name      = "test-backup-plan"
  backup_rule_name      = "test-backup-rule"
  backup_schedule       = "cron(26 3 * * ? *)"
  backup_start_window   = 60
  cold_storage_after    = 30
  delete_after          = 365
  backup_selection_name = "test-backup-selection"
  backup_resources      = local.ec2_instance_arns
  backup_role_name      = "test-backup-role"
}
```

## Variables

- `kms_alias_name`: The alias name for the KMS key.
- `backup_vault_name`: The name of the backup vault.
- `backup_plan_name`: The name of the backup plan.
- `backup_rule_name`: The name of the backup rule.
- `backup_schedule`: The schedule for the backup in cron format.
- `backup_start_window`: The start window for the backup.
- `cold_storage_after`: The number of days after which the backup should be moved to cold storage.
- `delete_after`: The number of days after which the backup should be deleted.
- `backup_selection_name`: The name of the backup selection.
- `backup_resources`: The ARNs of the resources to be backed up.
- `backup_role_name`: The name of the IAM role for the backup service.

## Resources Created

- `aws_kms_key`: KMS key for Backup Vault encryption.
- `aws_kms_alias`: Alias for the KMS key.
- `aws_iam_role`: IAM role for AWS Backup.
- `aws_iam_role_policy_attachment`: Attachment of the AWS Backup service role policy to the IAM role.
- `aws_backup_vault`: Backup vault.
- `aws_backup_plan`: Backup plan.
- `aws_backup_selection`: Assignment of resources to the backup plan.

## License

This module is licensed under the MIT License.

---
