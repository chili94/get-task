#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
#echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
wget -O /var/www/html/index.html https://basichtml344.s3.us-east-2.amazonaws.com/html.txt
chown -R apache. /var/www/html
