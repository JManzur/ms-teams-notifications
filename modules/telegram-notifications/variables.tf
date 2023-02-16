variable "instance_id" {}

variable "telegram_bot_token" {
  type        = string
  description = "[REQUIRED] The Incoming Webhook URL for the Teams Chat"
}

variable "telegram_chat_id" {
  type        = string
  description = "[REQUIRED] The Incoming Webhook URL for the Teams Chat"
}

variable "name_prefix" {
  type        = string
  description = "[REQUIRED] Short and friendly name used for naming and tagging"
}