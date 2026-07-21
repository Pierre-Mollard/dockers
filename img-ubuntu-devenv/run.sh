#!/usr/bin/bash
# Script to run image

docker run --rm -it --name ubuntu-devenv --hostname devenv img-ubuntu-devenv:latest bash
