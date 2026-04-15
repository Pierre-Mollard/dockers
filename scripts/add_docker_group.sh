#!/usr/bin/bash
# Script to add the docker group to current user

sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER
newgrp docker
