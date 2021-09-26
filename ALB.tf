resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg_vpc2.id]
  subnets            = [aws_subnet.publicsubnet2.id, aws_subnet.publicsubnet3.id]

  enable_deletion_protection = true
}

resource "aws_lb_target_group" "my_alb" {
  name     = "my-alb"
  port     = 8888
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc2.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "8888"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_alb.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_private_vpc2" {
  target_group_arn = aws_lb_target_group.my_alb.arn
  target_id        = aws_instance.ec2_private_vpc2.id
  port             = 8888
}

resource "aws_lb_target_group_attachment" "ec2_private2_vpc2" {
  target_group_arn = aws_lb_target_group.my_alb.arn
  target_id        = aws_instance.ec2_private2_vpc2.id
  port             = 8888
}

resource "aws_security_group" "alb_sg_vpc2" {
  vpc_id      = aws_vpc.vpc2.id
  name        = "ALB Security Group for vpc2"
  description = "ALB Security Group for vpc2"
  tags        = { Name = "${var.common_tags["Environment"]} -ALB-SG-VPC2" }
  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_vpc2, var.private_subnet3_vpc2]
  }

}
