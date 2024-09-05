resource "aws_vpc" "llptest-aws-vpc" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  instance_tenancy   = "default"
  tags = {
    Name = "llptest-aws-vpc"
  }
}
