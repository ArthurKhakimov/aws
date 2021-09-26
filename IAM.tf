resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access_profile"
  role = aws_iam_role.s3_access_role.name
}

resource "aws_iam_role" "s3_access_role" {
  name               = "s3_access"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.s3_access_role.id
}

resource "aws_iam_policy" "DenyActionsWithoutTags" {
  name        = "DenyActionsWithoutTags"
  path        = "/"
  description = "Deny launch EC2 instance and create EBS volume without some tags"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "ConditionalEC2creationOwner",
        "Effect" : "Deny",
        "Action" : "ec2:RunInstances",
        "Resource" : "arn:aws:ec2:*:*:instance/*",
        "Condition" : {
          "StringNotLike" : {
            "aws:RequestTag/Owner" : "*"
          }
        }
      },
      {
        "Sid" : "ConditionalEC2creationProject",
        "Effect" : "Deny",
        "Action" : "ec2:RunInstances",
        "Resource" : "arn:aws:ec2:*:*:instance/*",
        "Condition" : {
          "StringNotLike" : {
            "aws:RequestTag/Project" : "*"
          }
        }
      },
      {
        "Sid" : "ConditionalEC2creationEnvironment",
        "Effect" : "Deny",
        "Action" : "ec2:RunInstances",
        "Resource" : "arn:aws:ec2:*:*:instance/*",
        "Condition" : {
          "StringNotLike" : {
            "aws:RequestTag/Environment" : "*"
          }
        }
      },
      {
        "Sid" : "ConditionalEBScreationOwner",
        "Effect" : "Deny",
        "Action" : "ec2:CreateVolume",
        "Resource" : "arn:aws:ec2:*:*:volume/*",
        "Condition" : {
          "StringNotLike" : {
            "aws:RequestTag/Owner" : "*"
          }
        }
      },
      {
        "Sid" : "ConditionalEBScreationProject",
        "Effect" : "Deny",
        "Action" : "ec2:CreateVolume",
        "Resource" : "arn:aws:ec2:*:*:volume/*",
        "Condition" : {
          "StringNotLike" : {
            "aws:RequestTag/Project" : "*"
          }
        }
      },
      {
        "Sid" : "ConditionalEBScreationEnvironment",
        "Effect" : "Deny",
        "Action" : "ec2:CreateVolume",
        "Resource" : "arn:aws:ec2:*:*:volume/*",
        "Condition" : {
          "StringNotLike" : {
            "aws:RequestTag/Environment" : "*"
          }
        }
      }
    ]
  })
}
