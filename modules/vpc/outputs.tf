
#output the whole vpc created
output "aws_vpc_id" {
  value = aws_vpc.my-vpc.id
}