#!/bin/bash

# Check if running as root, if not, exit
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

# Check if web.html exists
if [ ! -f "/var/www/html/web.html" ]; then
  echo "Error: web.html does not exist in the current directory"
  exit 1
fi

# Check if Apache is running
if systemctl is-active --quiet apache2; then
  echo "Apache is running"
else
  echo "Warning: Apache doesn't appear to be running"
fi

# Backup the original index.html if it exists
if [ -f "/var/www/html/index.html" ]; then
  echo "Backing up original index.html to index.html.bak"
  cp /var/www/html/index.html /var/www/html/index.html.bak
fi

# Replace index.html with web.html
echo "Replacing index.html with web.html"
cp /var/www/html/web.html /var/www/html/index.html

# Set proper permissions
echo "Setting proper permissions"
chmod 644 /var/www/html/index.html

# No need to restart Apache since we're just changing a static file
echo "Done! The new index.html is now in place."

# Optional: verify the file exists
if [ -f "/var/www/html/index.html" ]; then
  echo "Verified: /var/www/html/index.html is in place"
else
  echo "Error: Something went wrong, index.html is missing"
fi
