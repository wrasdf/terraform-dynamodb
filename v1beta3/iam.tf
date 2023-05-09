data "aws_partition" "this" {}
data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "this_assume_role" {
  count = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count                 = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  name                  = var.backup_iam_role_arn == null ? "kube-backup-${var.name}-role" : var.backup_iam_role_arn
  path                  = "/k8s/"
  permissions_boundary  = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/ap-service-boundary"
  assume_role_policy    = data.aws_iam_policy_document.this_assume_role[0].json

  tags = merge(
    local.default_tags,
    var.tags,
    {
      name = format("%s", var.name)
    },
  )
}

# Tag policy
data "aws_iam_policy_document" "this_tag_policy_document" {
  count      = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "backup:ListTags",
      "backup:TagResource",
      "backup:UntagResource",
      "tag:GetResources"
    ]
  }
}

resource "aws_iam_policy" "this_tag_policy" {
  count       = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  description = "AWS Backup Tag policy"
  policy      = data.aws_iam_policy_document.this_tag_policy_document[0].json
}

resource "aws_iam_role_policy_attachment" "this_tag_policy_attach" {
  count      = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  policy_arn = aws_iam_policy.this_tag_policy[0].arn
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "this_policy_attach" {
  count      = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  policy_arn = "arn:${data.aws_partition.this.partition}:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "this_s3_policy_attach" {
  count      = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  policy_arn = "arn:${data.aws_partition.this.partition}:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup"
  role       = aws_iam_role.this[0].name
}

# Restores policy
resource "aws_iam_role_policy_attachment" "this_restores_policy_attach" {
  count      = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  policy_arn = "arn:${data.aws_partition.this.partition}:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "this_restores_s3_policy_attach" {
  count      = var.backup_enabled && var.backup_iam_role_arn == null ? 1 : 0
  policy_arn = "arn:${data.aws_partition.this.partition}:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore"
  role       = aws_iam_role.this[0].name
}