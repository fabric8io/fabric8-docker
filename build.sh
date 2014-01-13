#!/usr/bin/env bash

echo "building the Docker containers for Fuse and Fuse Fabric"
docker build -t fabric8:java java
docker build -t fabric8:fabric8 fabric8

