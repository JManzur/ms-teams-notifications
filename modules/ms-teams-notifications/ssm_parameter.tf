#Encrypted string using default SSM KMS key
resource "aws_ssm_parameter" "secret" {
  name        = lower("/${var.name_prefix}/webhook_url")
  description = "${var.name_prefix} Webhook URL"
  type        = "SecureString"
  value       = var.webhook_url

  tags = { Name = "${var.name_prefix}-Webhook-Secret" }
}