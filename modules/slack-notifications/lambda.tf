data "archive_file" "slack_notification" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/"
  output_path = "${path.module}/output_lambda_zip/slack_notification.zip"
}

resource "aws_lambda_function" "slack_notification" {
  filename      = data.archive_file.slack_notification.output_path
  function_name = "${var.name_prefix}-Notification"
  role          = aws_iam_role.slack_notification.arn
  handler       = "main_handler.lambda_handler"
  description   = "${var.name_prefix}-Notification"
  tags          = { Name = "${var.name_prefix}-Notification" }

  source_code_hash = data.archive_file.slack_notification.output_path
  runtime          = "python3.9"
  timeout          = "900"

  environment {
    variables = {
      secret_ssm_parameter = aws_ssm_parameter.secret.name
    }
  }
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_notification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.slack_notification.arn
}