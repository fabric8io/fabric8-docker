#!/usr/bin/env bash

echo "building the Docker containers for Fuse and Fuse Fabric"
sudo docker build -t jboss-fuse:java java
sudo docker build -t jboss-fuse:fuse fuse
sudo docker build -t jboss-fuse:fuse-standalone fuse-standalone

