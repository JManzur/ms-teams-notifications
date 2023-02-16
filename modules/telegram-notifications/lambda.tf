data "archive_file" "telegram_notification" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/"
  output_path = "${path.module}/output_lambda_zip/telegram_notification.zip"
}

resource "aws_lambda_function" "telegram_notification" {
  filename      = data.archive_file.telegram_notification.output_path
  function_name = "MS-Teams-Notification"
  role          = aws_iam_role.telegram_notification.arn
  handler       = "main_handler.lambda_handler"
  description   = "MS-Teams-Notification"
  tags          = { Name = "MS-Teams-Notification" }

  source_code_hash = data.archive_file.telegram_notification.output_path
  runtime          = "python3.9"
  timeout          = "900"

  environment {
    variables = {
      telegram_bot_token_ssm_parameter = aws_ssm_parameter.secret["telegram_bot_token"].name
      telegram_chat_id_ssm_parameter   = var.telegram_chat_id
    }
  }
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.telegram_notification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.telegram_notification.arn
}