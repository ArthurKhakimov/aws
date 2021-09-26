#!/bin/bash
yum -y update
sudo amazon-linux-extras install nginx1
my_ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
my_AZ=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone`
my_region=`curl http://169.254.169.254/latest/meta-data/placement/region`
echo "<h2>My IP: $my_ip  My region: $my_region  My availability zone: $my_AZ</h2><br>Build by Terraform!"  >  /usr/share/nginx/html/index.html
sudo sed -i 's/listen       80/listen       8888/g' /etc/nginx/nginx.conf
sudo service nginx start
chkconfig nginx on
sudo adduser teacher
echo teacher:te@cher2021 | sudo chpasswd
sudo usermod -aG wheel teacher
mkdir /home/teacher/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkBIEsfJD6d0J4tqTnVq4z3Ve0bop71b+27j75gncRsLdAHLVg/InhJdrtnVszNGzPIPTXM8jsb/cc0e0JDD7Teoqz0YxJH+ZhY5Y6iy5n8Vx+CCWr5Rra5IpfJclvDPbH+okiUqGyt1fmvS+VkoBWxOFiAOsfdSdTwJWyGs0kplZouOh93cRc/9mp16mNcR5B86+ORLrMZCq3ZGVj2F3YjlhXb1/aUz7Mi1E6Ze9UQQe2oKqf4w8wXIiSejCcrsZ9CT6SX28Kqw2Ilb+7cr84vXIQDKxZySupztn8qMFlDvtoeK4b+RvEtpRmJaC/no9yjTeDTnBYVsV+vQvxiaaeLzkbPRhd0Ovlayoz/gXqI4DOCaQTfISHxG7X+NLfpW6Hmvgf+2i9OStUMJatDx6y1BAj5cjBKo1JRS73U2o5wYYTAlq6jaDAUzWE8Ili7cZ2Qx2dz5uFq6S8NteIt9yR6LsfaHYKG/5WmaA3LOnYAqV+S7nq2WQVQ2Z5bzpJC9s= andrey@MBP-Andrey" > /home/teacher/.ssh/authorized_keys
sudo chown teacher:teacher /home/teacher/.ssh; sudo chown teacher:teacher /home/teacher/.ssh/authorized_keys
chmod 700 /home/teacher/.ssh; chmod 640 /home/teacher/.ssh/authorized_keys
