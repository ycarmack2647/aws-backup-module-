# Output the ID of the KMS key used for Backup Vault encryption
output "kms_key_id" {
  description = "The ID of the KMS key used for Backup Vault encryption"
  value       = aws_kms_key.kms_key.id
}

# Output the name of the KMS alias
output "kms_alias_name" {
  description = "The name of the KMS alias"
  value       = aws_kms_alias.kms_alias.name
}

# Output the name of the backup vault
output "backup_vault_name" {
  description = "The name of the backup vault"
  value       = aws_backup_vault.backup_vault.name
}

# Output the ID of the backup plan
output "backup_plan_id" {
  description = "The ID of the backup plan"
  value       = aws_backup_plan.backup_plan.id
}

# Output the ID of the backup selection
output "backup_selection_id" {
  description = "The ID of the backup selection"
  value       = aws_backup_selection.backup_selection.id
}

# Output the name of the IAM role for AWS Backup
output "iam_role_name" {
  description = "The name of the IAM role for AWS Backup"
  value       = aws_iam_role.iam_role.name
}
