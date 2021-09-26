resource "aws_instance" "bastion_host_vpc1" {
  ami                    = "ami-087c17d1fe0178315"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_host_vpc1.id, ]
  user_data              = file("user_data_bastion.sh")
  subnet_id              = aws_subnet.publicsubnet1.id
  key_name               = "Bastion-key"
  tags                   = { Name = "${var.common_tags["Environment"]} -Bastion1" }
}
/*resource "aws_instance" "ec2_private_vpc1" {
  ami                    = "ami-087c17d1fe0178315"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_host_vpc1.id, ]
  user_data              = file("user_data_nginx.sh")
  subnet_id              = aws_subnet.privatesubnet1.id
  key_name               = "Bastion-key"
  tags                   = { Name = "${var.common_tags["Environment"]} -EC2-Priv1" }
}
resource "aws_instance" "bastion_host_vpc2" {
  ami                    = "ami-087c17d1fe0178315"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_host_vpc2.id, ]
  user_data              = file("user_data_bastion.sh")
  subnet_id              = aws_subnet.publicsubnet2.id
  key_name               = "Bastion-key"
  tags                   = { Name = "${var.common_tags["Environment"]} -Bastion2" }
}*/
resource "aws_instance" "ec2_private_vpc2" {
  ami                    = "ami-087c17d1fe0178315"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.s3_access_profile.id
  vpc_security_group_ids = [aws_security_group.bastion_host_vpc2.id, ]
  user_data              = file("user_data_nginx.sh")
  subnet_id              = aws_subnet.privatesubnet2.id
  key_name               = "Bastion-key"
  tags                   = { Name = "${var.common_tags["Environment"]} -EC2-nginx1" }
}
resource "aws_instance" "ec2_private2_vpc2" {
  ami                    = "ami-087c17d1fe0178315"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.s3_access_profile.id
  vpc_security_group_ids = [aws_security_group.bastion_host_vpc2.id, ]
  user_data              = file("user_data_nginx.sh")
  subnet_id              = aws_subnet.privatesubnet3.id
  key_name               = "Bastion-key"
  tags                   = { Name = "${var.common_tags["Environment"]} -EC2-nginx2" }
}

resource "aws_security_group" "bastion_host_vpc1" {
  vpc_id      = aws_vpc.vpc1.id
  name        = "Bastion host Security Group"
  description = "Bastion host Security Group"
  tags        = { Name = "${var.common_tags["Environment"]} -Common-SG-VPC1" }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc1_cidr, var.vpc2_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_host_vpc2" {
  vpc_id      = aws_vpc.vpc2.id
  name        = "Bastion host Security Group for vpc2"
  description = "Bastion host Security Group for vpc2"
  tags        = { Name = "${var.common_tags["Environment"]} -Common-SG-VPC2" }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc1_cidr, var.vpc2_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

data "aws_instance" "bastion" {
  instance_id = aws_instance.bastion_host_vpc1.id
}

data "aws_ebs_volume" "ebs_volume" {
  filter {
    name   = "attachment.instance-id"
    values = ["${aws_instance.ec2_private_vpc2.id}"]
  }
}

resource "null_resource" "change_EBS_volume_on_Bastion" {
  provisioner "local-exec" {
    command = "aws ec2 modify-volume --volume-type gp2 --size 10 --volume-id '${data.aws_ebs_volume.ebs_volume.id}'"
  }
  depends_on = [aws_instance.bastion_host_vpc1]
}

resource "null_resource" "expand_partition" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/Bastion-key.pem")
    host        = data.aws_instance.bastion.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'sudo growpart /dev/xvda 1'| sudo tee -a /root/log.txt",
      "sudo growpart /dev/xvda 1| sudo tee -a /root/log.txt",
      "echo 'sudo xfs_growfs -d /'| sudo tee -a /root/log.txt",
      "sudo xfs_growfs -d /| sudo tee -a /root/log.txt",
    ]
  }
  depends_on = [null_resource.change_EBS_volume_on_Bastion]
}
/*resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access_profile"
  role = aws_iam_role.s3_access_role.name
}
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  path        = "/"
  description = "s3 access policy for ami"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Principal" : "*",
        "Action" : [
          "s3:GetObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::amazonlinux.${var.region}.amazonaws.com/*",
          "arn:aws:s3:::amazonlinux-2-repos-${var.region}/*"
        ]
      }
    ]
  })
}

/*resource "aws_iam_role" "s3_access_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}*/
