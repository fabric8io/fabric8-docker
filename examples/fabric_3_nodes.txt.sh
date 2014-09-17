#!/bin/bash

##########################################################################################################
# Description:
# This example will guide you through a simple Red Hat JBoss Fuse setup.
# We are going to start 3 docker container that will represent the nodes of your network.
# On the noode called "root" we will be manually starting the instance of JBoss FUse.
# Then we will be start using Fabric to provision other JBoss Fuse instances on the remaining 2 nodes.
# At the end of this process we will join all them togheter to build a distributed registry based,
# leveraging Apache Zookeeper.
#
# Dependencies:
# - docker 
# - sshpass, used to avoid typing the pass everytime (not needed if you are invoking the commands manually)
# to install on Fedora/Centos/Rhel: 
# sudo yum install -y docker-io sshpass
# 
# to install on MacOSX:
# sudo port install sshpass
# or
# brew install https://raw.github.com/eugeneoden/homebrew/eca9de1/Library/Formula/sshpass.rb
#
# Prerequesites:
# - run docker in case it's not already
# sudo service docker start
#
# Notes:
# - if you don't want to use docker, just assign to the ip addresses of your own boxes to environment variable
#######################################################################################################


################################################################################################
#####             Preconfiguration and helper functions. Skip if not interested.           #####
################################################################################################


# set debug mode
set -x

# configure logging to print line numbers
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# ulimits values needed by the processes inside the container
ulimit -u 4096
ulimit -n 4096

# helper ssh macro for password less authentication + ssh optimization "-p admin" is the password that it types for you
alias ssh="sshpass -p admin ssh -p 8101 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR"

# remove old docker containers with the same names
docker stop root  
docker stop fab02 
docker stop fab03 
docker rm root 
docker rm fab02 
docker rm fab03 

# expose ports to localhost, uncomment to enable always
# EXPOSE_PORTS="-P"
if [[ x$EXPOSE_PORTS == xtrue ]] ; then EXPOSE_PORTS=-P ; fi

# halt on errors
set -e

# create your lab
docker run -d -t -i $EXPOSE_PORTS --name root  fabric8/fabric8 sh -c "service sshd start; bash"
docker run -d -t -i $EXPOSE_PORTS --name fab02 fabric8/fabric8 sh -c "service sshd start; bash"
docker run -d -t -i $EXPOSE_PORTS --name fab03 fabric8/fabric8 sh -c "service sshd start; bash"

# assign ip addresses to env variable, despite they should be constant on the same machine across sessions
IP_ROOT=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' root)
IP_FAB02=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' fab02)
IP_FAB03=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' fab03)

########### aliases to preconfigure ssh and scp verbose to type options

# full path of your ssh, used by the following helper aliases
SSH_PATH=$(which ssh) 
### ssh aliases to remove some of the visual clutter in the rest of the script
# alias to connect to your docker images
alias ssh="$SSH_PATH -o ConnectionAttempts=180 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR"
alias ssh2host="$SSH_PATH -o UserKnownHostsFile=/dev/null -o ConnectionAttempts=180 -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR fuse@$IP_ROOT"
# alias to connect to the ssh server exposed by JBoss Fuse. uses sshpass to script the password authentication
alias ssh2fabric="sshpass -p admin $SSH_PATH -p 8101 -o ConnectionAttempts=180 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR admin@$IP_ROOT"
# alias to connect to the ssh server exposed by JBoss Fuse. uses sshpass to script the password authentication
alias ssh2fab02="sshpass -p admin $SSH_PATH -p 8101 -o ConnectionAttempts=180 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR admin@$IP_FAB02"
alias ssh2fab03="sshpass -p admin $SSH_PATH -p 8101 -o ConnectionAttempts=180 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR admin@$IP_FAB03"


################################################################################################
#####                             Tutorial starts here                                     #####
################################################################################################

# start fuse on root node 
ssh2host "env FABRIC8_KARAF_NAME=root FABRIC8_BINDADDRESS=0.0.0.0 JAVA_HOME=/usr/lib/jvm/jre /home/fuse/fabric8/bin/start"

############################# here you are starting to interact with Fuse/Karaf

# wait for critical components to be available before progressing with other steps
ssh2fabric "wait-for-service -t 300000 org.apache.felix.fileinstall.ArtifactListener"

# create a new fabric AND wait for the Fabric to be up and ready to accept the following commands
ssh2fabric "fabric:create --clean -r localip -g localip --wait-for-provisioning" 


# show current containers
ssh2fabric "container-list"

# provision fabric nodes
ssh2fabric "container-create-ssh --resolver localip --host $IP_FAB02 --user fuse  --path /home/fuse/provisioned fab02"
ssh2fabric "container-create-ssh --resolver localip --host $IP_FAB03 --user fuse  --path /home/fuse/provisioned fab03"

# wait for containers to be ready
ssh2fab02 "wait-for-service -t 300000 org.apache.karaf.features.FeaturesService"
ssh2fab03 "wait-for-service -t 300000 org.apache.karaf.features.FeaturesService"


# wait for them to be provisioned. check with container-list
# join the node to the ensemble (-f to bypass the confirmation)
ssh2fabric "ensemble-add -f fab02 fab03"

set +x
echo "
----------------------------------------------------
Fuse Fabric 3 nodes demo
----------------------------------------------------
FABRIC ROOT: 
- ip:          $IP_ROOT
- ssh:         ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null fuse@$IP_ROOT
- karaf:       ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null admin@$IP_ROOT -p8101
- tail logs:   ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null fuse@$IP_ROOT 'tail -F /home/fuse/fabric8/data/karaf.out'

FABRIC 02: 
- ip:         $IP_FAB02
- ssh:        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null fuse@$IP_FAB02
- tail logs:  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $IP_FAB02 -l fuse 'tail -F /home/fuse/provisioned/fab02/fabric8-*/data/log/karaf.log'

FABRIC 03:  
- ip:         $IP_FAB03
- ssh:        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null fuse@$IP_FAB03
- karaf:      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null admin@$IP_FAB03 -p8101
- tail logs:  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $IP_FAB03 -l fuse 'tail -F /home/fuse/provisioned/fab03/fabric8-*/data/log/karaf.log'

NOTE: If you are using Docker in a VM you may need extra config to route the traffic to the containers. One way to bypass this can be setting the environment variable EXPOSE_PORTS=true before running this script and than to use 'docker ps' to discover the exposed ports on your localhost.
----------------------------------------------------
Use command:

container-list

in Karaf on Fabric Root, to verify the list of available containers.

Use command:

ensemble-list

in Karaf on Fabric Root, to verify the status of your Zookeeper Ensemble.

"