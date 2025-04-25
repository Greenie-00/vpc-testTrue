resource "aws_vpc" "llptest-aws-vpc" {
  cidr_block       = var.aws_vpc_cidr_block
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  instance_tenancy = "default"
  tags = {
    Name = "llptest-aws-vpc"
  }
}


resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.llptest-aws-vpc.id
  cidr_block = var.aws_public_subnet_cidr

  tags = {
    Name = "public_subnet"
  }
}


resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.llptest-aws-vpc.id
  cidr_block = var.aws_private_subnet_cidr

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "llp_test_igw" {
  vpc_id = aws_vpc.llptest-aws-vpc.id

  tags = {
    Name = "internet gateway"
  }
}

