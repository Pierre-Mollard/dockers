#!/usr/bin/bash
# Script to build image

# Will build from the same directory (Dockerfile) with this name/version
docker build -t img-redhat-nvim:latest .
