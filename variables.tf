### Global variables:
variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    Service   = "Lambda-CloudWatch-Notifications",
    CreatedBy = "JManzur - https://jmanzur.com/"
    Env       = "POC"
  }
}

### EC2 Module:
variable "vpc_id" {
  description = "[REQUIRED] The VPC ID"
  type        = string

  validation {
    condition = (
      can(regex("^vpc-[a-z0-9]", var.vpc_id)) && length(substr(var.vpc_id, 4, 17)) == 8 ||
      can(regex("^vpc-[a-z0-9]", var.vpc_id)) && length(substr(var.vpc_id, 4, 17)) == 17
    )
    error_message = "Error: Invalid VPC ID. It must start with 'vpc-' followed by 8 or 17 alphanumeric characters."
  }
}

variable "public_subnet_id" {
  description = "[REQUIRED] The Public Subnet ID to place the EC2 instance"
  type        = string

  validation {
    condition     = can(regex("^subnet-[a-z0-9]", var.public_subnet_id)) && length(substr(var.public_subnet_id, 7, 17)) == 17
    error_message = "Error: Invalid Public Subnet ID. It must start with 'subnet-' followed by 17 alphanumeric characters."
  }
}

variable "ssh_key_name" {
  type        = string
  description = "[REQUIRED] The name of the SSH key pair used to access the EC2 instance."
}

### MS Teams Notification Module:
variable "teams_webhook_url" {
  type        = string
  description = "[REQUIRED] The Incoming Webhook URL for the Teams channel"
  default     = "url_placeholder" # Placeholder to avoid errors if var.deploy_ms_teams_notifications is set to false
}

### Slack Notification Module:
variable "slack_webhook_url" {
  type        = string
  description = "[REQUIRED] The Incoming Webhook URL for the Slack channel"
  default     = "url_placeholder" # Placeholder to avoid errors if var.deploy_slack_notifications is set to false
}

## Conditional modules deployments:
variable "deploy_ms_teams_notifications" {
  type        = bool
  description = "[OPTIONAL] If set to false, the module will not be deployed."
  default     = true
}

variable "deploy_slack_notifications" {
  type        = bool
  description = "[OPTIONAL] If set to false, the module will not be deployed."
  default     = true
}

variable "deploy_telegram_notifications" {
  type        = bool
  description = "[OPTIONAL] If set to false, the module will not be deployed."
  default     = true
}