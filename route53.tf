resource "aws_route53_zone" "private" {
  name = "test.local"
  vpc {
    vpc_id = aws_vpc.vpc1.id
  }
  vpc {
    vpc_id = aws_vpc.vpc2.id
  }
}
