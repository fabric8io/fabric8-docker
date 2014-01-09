#!/usr/bin/env bash

echo "Starting the fuse container"
docker run -p 8181 -d -t jboss-fuse:fuse-standalone
