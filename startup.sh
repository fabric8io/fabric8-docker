#!/bin/sh

echo starting Fabric8 container: $FABRIC8_KARAF_NAME connecting to ZooKeeper: $FABRIC8_ZOOKEEPER_URL using environment: $FABRIC8_FABRIC_ENVIRONMENT

# TODO allow this to be disabled via an env var
/usr/sbin/sshd -D &

# TODO if enabled should we tail the karaf log to work nicer with docker logs?
#tail -f /home/fuse/fabric8/data/log/karaf.log

/home/fuse/fabric8/bin/karaf server
