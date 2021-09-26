
provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc1" {
  cidr_block       = var.vpc1_cidr
  instance_tenancy = "default"
  tags             = { Name = "${var.common_tags["Environment"]}-VPC1" }
}

resource "aws_internet_gateway" "IGW1" {
  vpc_id = aws_vpc.vpc1.id
  tags   = { Name = "${var.common_tags["Environment"]}-IGW1" }
}

resource "aws_subnet" "publicsubnet1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.public_subnet_vpc1
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.common_tags["Environment"]}-PubSub1" }
}

resource "aws_subnet" "privatesubnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.private_subnet_vpc1
  tags       = { Name = "${var.common_tags["Environment"]}-PrivSub1" }
}

resource "aws_route_table" "PublicRT1" {
  vpc_id = aws_vpc.vpc1.id
  tags   = { Name = "${var.common_tags["Environment"]}-PubRT1" }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW1.id
  }
}

resource "aws_route_table" "PrivateRT1" {
  vpc_id = aws_vpc.vpc1.id
  tags   = { Name = "${var.common_tags["Environment"]}-PrivRT1" }
}

resource "aws_route_table_association" "PublicRT1association" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.PublicRT1.id
}

resource "aws_route_table_association" "PrivateRT1association" {
  subnet_id      = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.PrivateRT1.id
}

resource "aws_vpc_endpoint" "s3_vpc1" {
  vpc_id          = aws_vpc.vpc1.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.PrivateRT1.id]
  tags            = { Name = "${var.common_tags["Environment"]}-S3-Endpoint1" }
}
