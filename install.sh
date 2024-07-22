#!/bin/bash

# Install necessary dependencies
sudo apt-get update
sudo apt-get install -y net-tools docker.io nginx

# Copy the devopsfetch script to /usr/local/bin
sudo cp devopsfetch.sh /usr/local/bin/devopsfetch

# Create a systemd service
cat <<EOF | sudo tee /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOps Fetch Service

[Service]
ExecStart=/usr/local/bin/devopsfetch -t "1h"
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl enable devopsfetch.service
sudo systemctl start devopsfetch.service

# Set up log rotation
cat <<EOF | sudo tee /etc/logrotate.d/devopsfetch
/var/log/devopsfetch.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0640 root adm
    postrotate
        systemctl restart devopsfetch.service
    endscript
}
EOF
