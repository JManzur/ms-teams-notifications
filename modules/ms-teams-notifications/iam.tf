# IAM Policy Source
data "aws_iam_policy_document" "ms_teams_notification_policy" {
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
}

data "aws_iam_policy_document" "ms_teams_notification_assume" {
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
resource "aws_iam_policy" "ms_teams_notification" {
  name        = "MS-Teams-Notification-Lambda-Policy"
  path        = "/"
  description = "Permissions to trigger the Lambda"
  policy      = data.aws_iam_policy_document.ms_teams_notification_policy.json
  tags        = { Name = "MS-Teams-Notification-Lambda-Policy" }
}

# IAM Role (Lambda execution role)
resource "aws_iam_role" "ms_teams_notification" {
  name               = "MS-Teams-Notification-Lambda-Role"
  assume_role_policy = data.aws_iam_policy_document.ms_teams_notification_assume.json
  tags               = { Name = "MS-Teams-Notification-Lambda-Role" }
}

# Attach Role and Policy
resource "aws_iam_role_policy_attachment" "ms_teams_notification" {
  role       = aws_iam_role.ms_teams_notification.name
  policy_arn = aws_iam_policy.ms_teams_notification.arn
}