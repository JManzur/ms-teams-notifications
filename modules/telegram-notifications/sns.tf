resource "aws_sns_topic" "telegram_notification" {
  name = "MS-Teams-Notification"
}

resource "aws_sns_topic_subscription" "telegram_notification" {
  topic_arn = aws_sns_topic.telegram_notification.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.telegram_notification.arn
}
