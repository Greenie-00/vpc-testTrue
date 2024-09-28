
#output the whole vpc created
output "aws_vpc" {
  value = aws_vpc.my-vpc.id
}