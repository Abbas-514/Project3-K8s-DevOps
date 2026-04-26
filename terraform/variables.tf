variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type (t3.medium recommended for MicroK8s)"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the existing AWS key pair"
  type        = string
  default     = "project3-key"
}
