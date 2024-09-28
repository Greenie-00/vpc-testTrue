

module "my-vpc"{
  source = "./modules/vpc"
  aws_vpc_cidr_block = var.aws_vpc_cidr_block
  aws_public_subnet_cidr = var.aws_public_subnet_cidr
  aws_private_subnet_cidr = var.aws_private_subnet_cidr
}


