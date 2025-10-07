# VPC
resource "aws_vpc" "grantest-aws-vpc" {
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name        = "grantest-aws-vpc"
    Environment = "test"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "grantest_igw" {
  vpc_id = aws_vpc.grantest-aws-vpc.id

  tags = {
    Name        = "grantest-igw"
    Environment = "test"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.grantest-aws-vpc.id
  cidr_block              = var.aws_public_subnet_1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-1"
    Type        = "Public"
    Environment = "test"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.grantest-aws-vpc.id
  cidr_block              = var.aws_public_subnet_2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-2"
    Type        = "Public"
    Environment = "test"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.grantest-aws-vpc.id
  cidr_block        = var.aws_private_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "private-subnet-1"
    Type        = "Private"
    Environment = "test"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.grantest-aws-vpc.id
  cidr_block        = var.aws_private_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name        = "private-subnet-2"
    Type        = "Private"
    Environment = "test"
  }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_gateway_1_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.grantest_igw]

  tags = {
    Name        = "nat-gateway-1-eip"
    Environment = "test"
  }
}

resource "aws_eip" "nat_gateway_2_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.grantest_igw]

  tags = {
    Name        = "nat-gateway-2-eip"
    Environment = "test"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name        = "nat-gateway-1"
    Environment = "test"
  }

  depends_on = [aws_internet_gateway.grantest_igw]
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_2_eip.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name        = "nat-gateway-2"
    Environment = "test"
  }

  depends_on = [aws_internet_gateway.grantest_igw]
}

# Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.grantest-aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.grantest_igw.id
  }

  tags = {
    Name        = "public-route-table"
    Environment = "test"
  }
}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.llptest-aws-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }

  tags = {
    Name        = "private-route-table-1"
    Environment = "test"
  }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.llptest-aws-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }

  tags = {
    Name        = "private-route-table-2"
    Environment = "test"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name              = "/aws/vpc/flowlogs"
  retention_in_days = 14

  tags = {
    Name        = "vpc-flow-logs"
    Environment = "test"
  }
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "vpc-flow-log-role"
    Environment = "test"
  }
}

# IAM Policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# VPC Flow Logs
resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.grantest-aws-vpc.id

  tags = {
    Name        = "vpc-flow-logs"
    Environment = "test"
  }
}

