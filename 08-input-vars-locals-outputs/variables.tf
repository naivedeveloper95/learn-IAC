variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The type of managed EC2 instances."

  validation {
    condition     = startswith(var.ec2_instance_type, "t2")
    error_message = "Only t2 instance types are allowed."
  }
}

variable "ec2_volume_config" {
  type = map(object({
    size = number
    type = string
  }))
  default = {
    config = {
      size = 10
      type = "gp3"
    }
  }
  description = "The size and type in GB of the EC2 root volume."
}

variable "ec2_volume_type" {
  type        = string
  default     = "gp3"
  description = "The type of the EC2 root volume."
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to resources."
}