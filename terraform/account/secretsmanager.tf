resource "aws_secretsmanager_secret" "test_key" {
  name                    = "aws-whitepaper-example-key"
  kms_key_id              = aws_kms_key.secrets_manager.key_id
  recovery_window_in_days = 0
  provider                = aws.sandbox
}

resource "aws_kms_key" "secrets_manager" {
  description             = "Secrets Manager encryption ${local.environment}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.secrets_manager_kms.json
  provider                = aws.sandbox
}

resource "aws_kms_alias" "secrets_manager_alias" {
  name          = "alias/whitepaper_secrets_manager_encryption"
  target_key_id = aws_kms_key.secrets_manager.key_id
  provider      = aws.sandbox
}

data "aws_iam_policy_document" "secrets_manager_kms" {
  statement {
    sid       = "Enable Root account permissions on Key"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }

  statement {
    sid       = "Allow Key to be used for Decryption"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/operator",
      ]
    }
  }

  statement {
    sid       = "Key Administrator"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/breakglass",
      ]
    }
  }
}
