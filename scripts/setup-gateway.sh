#!/bin/bash
set -e

echo "=== Setting up gateway-vm ==="

sudo apt update -y
sudo apt install -y nginx

# CALLER_IP is passed in as an argument: ./setup-gateway.sh <caller_private_ip>
CALLER_IP=$1

sudo tee /etc/nginx/sites-available/alchemyst << NGINX
server {
    listen 80;

    location / {
        proxy_pass http://${CALLER_IP}:3111;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_read_timeout 120s;
    }
}
NGINX

sudo ln -sf /etc/nginx/sites-available/alchemyst /etc/nginx/sites-enabled/alchemyst
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

echo "=== gateway-vm setup complete ==="
