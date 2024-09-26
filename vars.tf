variable "aws_region" {
  type        = string
  description = "Name of AWS region to place resources"
  default = "us-east-1"
}

variable "aws_access_key" {
  type = string
  description = "Access Key as a workaround."
  default = ""
}

variable "aws_secret_key" {
  type = string
  description = "Secret Key as a workaround."
  default = ""
}

variable "aws_vpc_cidr_block" {
  type = string
  default = ""
}

variable "aws_public_subnet_cidr"{
  type = string
  default = ""
}

variable "aws_private_subnet_cidr"{
  type = string
  default = ""
}