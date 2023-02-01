### Global variables:
variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "project-tags" {
  type = map(string)
  default = {
    Service   = "MS-Teams-Notification",
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
    error_message = "The VPC ID is invalid. Must be of format 'vpc-xxxxxxxx' and length of eather 8 or 17"
  }
}

variable "public_subnet_id" {}
variable "ssh_key_name" {}

### MS Teama Notification Module
variable "teams_webhook_url" {}