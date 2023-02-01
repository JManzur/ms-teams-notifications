variable "instance_id" {}

variable "teams_webhook_url" {
  type        = string
  description = "[REQUIRED] The Incoming Webhook URL for the Teams Chat"
}