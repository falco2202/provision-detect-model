resource "aws_vpc" "my_vpc" {
  cidr_block           = local.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets_cidr_block)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.public_subnets_cidr_block, count.index)
  availability_zone = element(var.availability_zones)
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "public_subnets" {
  count = length(local.public_subnets_cidr_block)
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}