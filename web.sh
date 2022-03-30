#!/bin/bash
sudo yum install httpd -y
sudo systemctl restart httpd
sudo systemctl enable httpd
sudo echo "This is WebServer" > /var/www/html/index.html