data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# IAM Policy Source
data "aws_iam_policy_document" "telegram_notification_policy" {
  statement {
    sid    = "CloudWatchAccess"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid    = "GetParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${aws_ssm_parameter.secret.name}"]
  }

  statement {
    sid    = "KMSDecrypt"
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = ["arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/alias/aws/ssm"]
  }
}

data "aws_iam_policy_document" "telegram_notification_assume" {
  statement {
    sid    = "LambdaAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM Policy
resource "aws_iam_policy" "telegram_notification" {
  name        = "${var.name_prefix}-Notification-Lambda-Policy"
  path        = "/"
  description = "Permissions to trigger the Lambda"
  policy      = data.aws_iam_policy_document.telegram_notification_policy.json
  tags        = { Name = "${var.name_prefix}-Notification-Lambda-Policy" }
}

# IAM Role (Lambda execution role)
resource "aws_iam_role" "telegram_notification" {
  name               = "${var.name_prefix}-Notification-Lambda-Role"
  assume_role_policy = data.aws_iam_policy_document.telegram_notification_assume.json
  tags               = { Name = "${var.name_prefix}-Notification-Lambda-Role" }
}

# Attach Role and Policy
resource "aws_iam_role_policy_attachment" "telegram_notification" {
  role       = aws_iam_role.telegram_notification.name
  policy_arn = aws_iam_policy.telegram_notification.arn
}