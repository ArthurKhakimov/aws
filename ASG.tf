resource "aws_launch_template" "my_template" {
  name                                 = "my-template"
  image_id                             = "ami-087c17d1fe0178315"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = "Bastion-key"
  vpc_security_group_ids               = [aws_security_group.sg_ec2_private_vpc2.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.s3_access_profile.id
  }

}

resource "aws_autoscaling_group" "my_asg" {
  name                = "my-asg"
  vpc_zone_identifier = [aws_subnet.privatesubnet2.id, aws_subnet.privatesubnet3.id, ]
  desired_capacity    = 0
  min_size            = 0
  max_size            = 2

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}
