resource "aws_sns_topic" "ms_teams_notification" {
  name = "MS-Teams-Notification"
}

resource "aws_sns_topic_subscription" "ms_teams_notification" {
  topic_arn = aws_sns_topic.ms_teams_notification.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ms_teams_notification.arn
}
