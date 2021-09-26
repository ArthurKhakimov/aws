resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.vpc1.id
  vpc_id      = aws_vpc.vpc2.id
  auto_accept = true
  tags        = { Name = "${var.common_tags["Environment"]}-VPC-Peering" }
}

resource "aws_route" "privatesubnet1_to_vpc2" {
  route_table_id            = aws_route_table.PrivateRT1.id
  destination_cidr_block    = var.vpc2_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  #depends_on                = [aws_route_table.testing]
}
resource "aws_route" "privatesubnet2_to_vpc1" {
  route_table_id            = aws_route_table.PrivateRT2.id
  destination_cidr_block    = var.vpc1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  #depends_on                = [aws_route_table.testing]
}
resource "aws_route" "publicsubnet1_to_vpc2" {
  route_table_id            = aws_route_table.PublicRT1.id
  destination_cidr_block    = var.vpc2_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  #depends_on                = [aws_route_table.testing]
}
resource "aws_route" "publicsubnet2_to_vpc1" {
  route_table_id            = aws_route_table.PublicRT2.id
  destination_cidr_block    = var.vpc1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  #depends_on                = [aws_route_table.testing]
}
resource "aws_route" "privatesubnet3_to_vpc1" {
  route_table_id            = aws_route_table.PrivateRT3.id
  destination_cidr_block    = var.vpc1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  #depends_on                = [aws_route_table.testing]
}
resource "aws_route" "publicsubnet3_to_vpc1" {
  route_table_id            = aws_route_table.PublicRT3.id
  destination_cidr_block    = var.vpc1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  #depends_on                = [aws_route_table.testing]
}
