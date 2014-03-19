#!/usr/bin/env bash

echo "building the Docker container for http://fabric8.io/"
docker build -t fabric8:fabric8 .
