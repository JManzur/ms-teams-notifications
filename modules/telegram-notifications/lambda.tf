data "archive_file" "ms_teams_notification" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/"
  output_path = "${path.module}/output_lambda_zip/ms_teams_notification.zip"
}

resource "aws_lambda_function" "ms_teams_notification" {
  filename      = data.archive_file.ms_teams_notification.output_path
  function_name = "MS-Teams-Notification"
  role          = aws_iam_role.ms_teams_notification.arn
  handler       = "main_handler.lambda_handler"
  description   = "MS-Teams-Notification"
  tags          = { Name = "MS-Teams-Notification" }

  source_code_hash = data.archive_file.ms_teams_notification.output_path
  runtime          = "python3.9"
  timeout          = "900"

  environment {
    variables = {
      teams_webhook_url = var.teams_webhook_url
    }
  }
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ms_teams_notification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.ms_teams_notification.arn
}