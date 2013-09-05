#!/usr/bin/env bash

echo "building the Docker containers for Fuse and Fuse Fabric"
sudo docker build -t java java
sudo docker build -t fuse fuse
sudo docker build -t fuse-standalone fuse-standalone

