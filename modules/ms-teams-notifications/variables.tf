variable "instance_id" {
  type        = string
  description = "[REQUIRED] The ID of the EC2 instance."
}

variable "webhook_url" {
  type        = string
  description = "[REQUIRED] The Incoming Webhook URL for the Teams Chat"
}

variable "name_prefix" {
  type        = string
  description = "[REQUIRED] Short and friendly name used for naming and tagging"
}