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