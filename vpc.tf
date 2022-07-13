# Creating VPC
resource "aws_vpc" "awslab-vpc" {

  cidr_block = var.vpc_cidr_block
  # Enabling automatic hostname assigning
  enable_dns_hostnames = true
  tags = {
    Name = "awslab-vpc"
  }
}


# Creating Public subnet
resource "aws_subnet" "awslab-subnet-public" {
  depends_on = [
    aws_vpc.awslab-vpc
  ]

  vpc_id = aws_vpc.awslab-vpc.id

  cidr_block = var.public_cidr_block

  availability_zone = var.public_availability_zone

  map_public_ip_on_launch = true

  tags = {
    Name = "awslab-subnet-public"
  }
}

# Creating Private subnet
resource "aws_subnet" "awslab-subnet-private" {
  depends_on = [
    aws_vpc.awslab-vpc,
    aws_subnet.awslab-subnet-public
  ]

  vpc_id = aws_vpc.awslab-vpc.id

  cidr_block = var.private_cidr_block

  availability_zone = var.private_availability_zone

  tags = {
    Name = "awslab-subnet-private"
  }
}

resource "aws_internet_gateway" "Internet_Gateway" {
  depends_on = [
    aws_vpc.awslab-vpc,
    aws_subnet.awslab-subnet-public,
    aws_subnet.awslab-subnet-private
  ]

  vpc_id = aws_vpc.awslab-vpc.id

  tags = {
    Name = "IG-Public-Private-VPC"
  }
}

resource "aws_route_table" "Public-Subnet-RT" {
  depends_on = [
    aws_vpc.awslab-vpc,
    aws_internet_gateway.Internet_Gateway
  ]

  vpc_id = aws_vpc.awslab-vpc.id

  # NAT Rule
  route {
    cidr_block = var.nat_cidr_block
    gateway_id = aws_internet_gateway.Internet_Gateway.id
  }

  tags = {
    Name = "Route Table for Internet Gateway"
  }
}

resource "aws_route_table_association" "RT-IG-Association" {

  depends_on = [
    aws_vpc.awslab-vpc,
    aws_subnet.awslab-subnet-public,
    aws_subnet.awslab-subnet-private,
    aws_route_table.Public-Subnet-RT
  ]

  # Public Subnet ID
  subnet_id = aws_subnet.awslab-subnet-public.id

  route_table_id = aws_route_table.Public-Subnet-RT.id
}