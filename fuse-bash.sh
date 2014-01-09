#!/usr/bin/env bash

echo "Starting the fuse container"
docker run -p 8181 -i -t jboss-fuse:fuse /bin/bash
#docker run -p 58181:8181 -i -t jboss-fuse:fuse /bin/bash