variable "instance_id" {}

variable "webhook_url" {
  type        = string
  description = "[REQUIRED] The Incoming Webhook URL for the Slack Chat"
}

variable "name_prefix" {
  type        = string
  description = "[REQUIRED] Short and friendly name used for naming and tagging"
}