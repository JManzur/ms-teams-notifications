#Encrypted string using default SSM KMS key
resource "aws_ssm_parameter" "secret" {
  for_each = {
    telegram_bot_token = "${var.telegram_bot_token}",
    telegram_chat_id   = "${var.telegram_chat_id}"
  }
  name        = lower("/${each.key}/webhook_url")
  description = "${each.key} Webhook URL"
  type        = "SecureString"
  value       = each.value

  tags = { Name = "${each.key}-Webhook-Secret" }
}