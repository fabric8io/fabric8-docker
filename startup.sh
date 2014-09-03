#!/bin/sh

echo Welcome to fabric8: http://fabric8.io/
echo
echo Starting Fabric8 container ID: $FABRIC8_RUNTIME_ID
echo Connecting to ZooKeeper: $FABRIC8_ZOOKEEPER_URL using environment: $FABRIC8_FABRIC_ENVIRONMENT
echo Using bindaddress: $FABRIC8_BINDADDRESS

# TODO if enabled should we tail the karaf log to work nicer with docker logs?
#tail -f /home/fabric8/data/log/karaf.log

#sudo -u fabric8 /home/fabric8/fabric8-karaf/bin/fabric8 server
/home/fabric8/fabric8-karaf/bin/fabric8 server
