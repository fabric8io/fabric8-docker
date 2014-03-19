#!/bin/sh

echo Welcome to fabric8: http://fabric8.io/
echo
echo Starting Fabric8 container: $FABRIC8_KARAF_NAME 
echo Connecting to ZooKeeper: $FABRIC8_ZOOKEEPER_URL using environment: $FABRIC8_FABRIC_ENVIRONMENT
echo Using bindaddress: $FABRIC8_BINDADDRESS

# TODO allow this to be disabled via an env var
service sshd start

# TODO if enabled should we tail the karaf log to work nicer with docker logs?
#tail -f /home/fuse/fabric8/data/log/karaf.log

/home/fuse/fabric8/bin/karaf server
