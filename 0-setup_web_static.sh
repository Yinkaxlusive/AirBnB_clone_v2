#!/usr/bin/env bash
# This script sets up the web servers for the deployment of web_static

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y nginx
fi

# Create necessary directories if they don't exist
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a fake HTML file
echo "<html><head></head><body>Holberton School</body></html>" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create symbolic link /data/web_static/current
sudo ln -sf /data/web_static/releases/test /data/web_static/current

# Give ownership of /data/ to ubuntu user and group recursively
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config="location /hbnb_static/ {\n\talias /data/web_static/current/;\n}"
sudo sed -i "/# pass the PHP/,/#}/c\\$config" /etc/nginx/sites-available/default

# Restart Nginx
sudo systemctl restart nginx
