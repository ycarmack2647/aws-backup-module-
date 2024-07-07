# KMS Key for Backup Vault encryption
resource "aws_kms_key" "kms_key" {
  description = "KMS key for Backup Vault encryption"
}

# KMS Key alias
resource "aws_kms_alias" "kms_alias" {
  name          = var.kms_alias_name
  target_key_id = aws_kms_key.kms_key.key_id
}

# IAM Role for AWS Backup
resource "aws_iam_role" "iam_role" {
  name = var.backup_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the AWSBackupServiceRolePolicyForBackup IAM policy to the role
resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

# Create a backup vault
resource "aws_backup_vault" "backup_vault" {
  name        = var.backup_vault_name
  kms_key_arn = aws_kms_key.kms_key.arn
}

# Create a backup plan
resource "aws_backup_plan" "backup_plan" {
  name = var.backup_plan_name

  rule {
    rule_name         = var.backup_rule_name
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.backup_schedule
    start_window      = var.backup_start_window # Start within 60 minutes

    lifecycle {
      cold_storage_after = var.cold_storage_after
      delete_after       = var.delete_after
    }
  }
}

# Assign resources to the backup plan
resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = aws_iam_role.iam_role.arn
  name         = var.backup_selection_name
  plan_id      = aws_backup_plan.backup_plan.id

  resources = var.backup_resources
}
