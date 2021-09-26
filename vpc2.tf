

resource "aws_vpc" "vpc2" {
  cidr_block       = var.vpc2_cidr
  instance_tenancy = "default"
  tags             = { Name = "${var.common_tags["Environment"]}-VPC2" }
}

resource "aws_internet_gateway" "IGW2" {
  vpc_id = aws_vpc.vpc2.id
  tags   = { Name = "${var.common_tags["Environment"]}-IGW2" }
}

resource "aws_subnet" "publicsubnet2" {
  vpc_id                  = aws_vpc.vpc2.id
  availability_zone       = var.az1
  cidr_block              = var.public_subnet_vpc2
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.common_tags["Environment"]}-PubSub2" }
}

resource "aws_subnet" "publicsubnet3" {
  vpc_id                  = aws_vpc.vpc2.id
  availability_zone       = var.az2
  cidr_block              = var.public_subnet3_vpc2
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.common_tags["Environment"]}-PubSub3" }
}

resource "aws_subnet" "privatesubnet2" {
  vpc_id            = aws_vpc.vpc2.id
  availability_zone = var.az1
  cidr_block        = var.private_subnet_vpc2
  tags              = { Name = "${var.common_tags["Environment"]}-PrivSub2" }
}

resource "aws_subnet" "privatesubnet3" {
  vpc_id            = aws_vpc.vpc2.id
  availability_zone = var.az2
  cidr_block        = var.private_subnet3_vpc2 # CIDR block of private subnets
  tags              = { Name = "${var.common_tags["Environment"]}-PrivSub3" }
}

resource "aws_route_table" "PublicRT2" {
  vpc_id = aws_vpc.vpc2.id
  tags   = { Name = "${var.common_tags["Environment"]}-PubRT2" }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW2.id
  }
}

resource "aws_route_table" "PublicRT3" {
  vpc_id = aws_vpc.vpc2.id
  tags   = { Name = "${var.common_tags["Environment"]}-PubRT3" }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW2.id
  }
}


resource "aws_route_table" "PrivateRT2" {
  vpc_id = aws_vpc.vpc2.id
  tags   = { Name = "${var.common_tags["Environment"]}-PrivRT2" }
}

resource "aws_route_table" "PrivateRT3" {
  vpc_id = aws_vpc.vpc2.id
  tags   = { Name = "${var.common_tags["Environment"]}-PrivRT3" }
}

resource "aws_route_table_association" "PublicRT2association" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.PublicRT2.id
}

resource "aws_route_table_association" "PublicRT3association" {
  subnet_id      = aws_subnet.publicsubnet3.id
  route_table_id = aws_route_table.PublicRT3.id
}

resource "aws_route_table_association" "PrivateRT2association" {
  subnet_id      = aws_subnet.privatesubnet2.id
  route_table_id = aws_route_table.PrivateRT2.id
}

resource "aws_route_table_association" "PrivateRT3association" {
  subnet_id      = aws_subnet.privatesubnet3.id
  route_table_id = aws_route_table.PrivateRT3.id
}

resource "aws_vpc_endpoint" "s3_vpc2" {
  vpc_id          = aws_vpc.vpc2.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.PrivateRT2.id, aws_route_table.PrivateRT3.id]
  tags            = { Name = "${var.common_tags["Environment"]}-S3-Endpoint2" }
}
