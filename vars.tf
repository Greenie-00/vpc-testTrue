variable "aws_region" {
  type        = string
  description = "Name of AWS region to place resources"
  default     = "us-east-1"
}

variable "aws_access_key" {
  type        = string
  description = "Access Key as a workaround."
  default     = ""
}

variable "aws_secret_key" {
  type        = string
  description = "Secret Key as a workaround."
  default     = ""
}

variable "aws_vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "aws_public_subnet_1_cidr" {
  type        = string
  description = "CIDR block for public subnet 1"
  default     = "10.0.1.0/24"
}

variable "aws_public_subnet_2_cidr" {
  type        = string
  description = "CIDR block for public subnet 2"
  default     = "10.0.2.0/24"
}

variable "aws_private_subnet_1_cidr" {
  type        = string
  description = "CIDR block for private subnet 1"
  default     = "10.0.3.0/24"
}

variable "aws_private_subnet_2_cidr" {
  type        = string
  description = "CIDR block for private subnet 2"
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["us-east-1a", "us-east-1b"]
}