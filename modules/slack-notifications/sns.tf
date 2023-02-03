resource "aws_sns_topic" "slack_notification" {
  name = "${var.name_prefix}-Notification"
}

resource "aws_sns_topic_subscription" "slack_notification" {
  topic_arn = aws_sns_topic.slack_notification.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.slack_notification.arn
}
