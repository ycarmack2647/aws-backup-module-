# KMS variables
variable "kms_alias_name" {
  description = "The name of the KMS alias"
  type        = string
  default     = "alias/aws-backup-vault-key"
}

# IAM role variables
variable "backup_role_name" {
  description = "The name of the IAM role for AWS Backup"
  type        = string
  default     = "backup-role"
}

# Backup vault variables
variable "backup_vault_name" {
  description = "The name of the backup vault"
  type        = string
  default     = "aws-backup-vault"
}

# Backup plan variables
variable "backup_plan_name" {
  description = "The name of the backup plan"
  type        = string
  default     = "aws-backup-plan"
}

variable "backup_rule_name" {
  description = "The name of the backup rule"
  type        = string
  default     = "aws-backup-rule"
}

# The cron(0 12 * * ? *) expression is used to schedule the AWS Backup job.
# It means the backup job will run at 12:00 PM (noon) every day.
# Breakdown of the cron expression:
# 0: (0-59) minute (0th minute of the hour)
# 12: (0-23) hour (12 PM, noon)
# *: (1-31) any day of the month
# *: (1-12 or JAN-DEC) any month
# ?: no specific value (used when day of the month is not specified)
# *: (0-6 or SUN-SAT, where 0 is Sunday) any day of the week

variable "backup_schedule" {
  description = "The schedule for the backup plan"
  type        = string
  default     = "cron(0 12 * * ? *)"
}

variable "backup_start_window" {
  description = "The start window in minutes for the backup job"
  type        = number
  default     = 60
}

variable "cold_storage_after" {
  description = "The number of days to move backup to cold storage"
  type        = number
  default     = 30
}

variable "delete_after" {
  description = "The number of days to delete the backup"
  type        = number
  default     = 365
}

# Backup selection variables
variable "backup_selection_name" {
  description = "The name of the backup selection"
  type        = string
  default     = "backup-selection"
}

variable "backup_resources" {
  description = "The list of resources to include in the backup selection"
  type        = list(string)
  default     = ["arn:aws:ec2:us-east-1:account-number:instance/*"]
}
