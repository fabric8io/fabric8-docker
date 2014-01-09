#!/usr/bin/env bash

echo "building the Docker containers for Fuse and Fuse Fabric"
docker build -t jboss-fuse:java java
docker build -t jboss-fuse:fuse fuse
docker build -t jboss-fuse:fuse-standalone fuse-standalone

