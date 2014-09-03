#!/bin/sh

ADMIN_USERNAME=${ADMIN_USERNAME:-admin}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}

echo Welcome to fabric8: http://fabric8.io/
echo
echo Starting Fabric8 container ID: $FABRIC8_RUNTIME_ID
echo Using admin user:              ${ADMIN_USERNAME}
echo Connecting to ZooKeeper:       $FABRIC8_ZOOKEEPER_URL 
echo Environment:                   $FABRIC8_FABRIC_ENVIRONMENT
echo Using bindaddress:             $FABRIC8_BINDADDRESS

echo "admin=${ADMIN_USERNAME},${ADMIN_PASSWORD}" >> users.properties

export DOCKER_HOST=${DOCKER_HOST:-tcp://172.17.42.1:4243}

# Use exec to replace shell with process to ensure signals get handled correctly
exec /home/fabric8/fabric8-karaf/bin/fabric8 server
