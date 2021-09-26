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
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCe2X7vKEEVhZH0mfAeyDVJZqcYJUQLuwbepRZNjuXUH2QxaKqdxu75TOhz0PUguwQC0BgpDbqTCLlN8HuJeQx4LOwMxjwrwlLMyoVCHGU756BfExOpY7ljdl6WurfaAbAUYnj7tClZZq9csqzIYY9JRUAS78fYVfi0NFKAIaHxN7eaz46Eqe6jjIj+USuK5JySmO2EQHnCyrk41z169uNapMU17pdPX1K4FYFyakdey0X/iHvZLI7z3il01XUW2LnKEW34QWmb9y6k8hqOQ4GQkD9f4dteXCSYfiJkkVSPEI6CTvaniVhnfCUPd9iP/dsDqqkSqkZaw9xfpF/8slnIPDQSy3BPhLSSlLUBXq4BSLejuzCy68GfQQ+jwqSF6Xa4gpFkZCQhrwbMhScoDOJLcaDuajr7n1U/h9xRmI1dBLJ5/x1Spm/6vY/HCN9GyN2oOXh8aaSbzpS/lukzdL2tGliOLM/hqumNR8ckfVVvM6DLlR82cFfRm3yz2qcSJZ0= archi@laptop" > /home/teacher/.ssh/authorized_keys
sudo chown teacher:teacher /home/teacher/.ssh; sudo chown teacher:teacher /home/teacher/.ssh/authorized_keys
chmod 700 /home/teacher/.ssh; chmod 640 /home/teacher/.ssh/authorized_keys
