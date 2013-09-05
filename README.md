fuse-dockerfiles
================

Dockerfiles to create Fuse containers in docker.io

Once you have [installed docker](https://www.docker.io/gettingstarted/#h_installation) you should be able to create the containers via the following:

If you are on OS X then see the [Building-OSX.md](https://github.com/jboss-fuse/fuse-dockerfiles/blob/master/Building-OSX.md#using-docker-on-os-x) document.

    git clone git@github.com:fusesource/fuse-dockerfiles.git
    cd fuse-dockerfiles
    ./build

Then you should have the various containers available to play with: java, fuee etc.


Images
------

* **java**: creates a container which has a JVM installed with JAVA_HOME set etc
* **fuse**: installs a fuse-fabric distro into /home/fuse/fuse-fabric
* **fuse-standalone**: a running stand alone JBoss Fuse container
* **fuse-fabric**: runs a Fuse Fabric Registry (auto-creating a ZooKeeper ensemble)
* **fuse-join**: runs a Fuse container and joins an existing Fuse Fabric
    
    
Running Fuse Standalone
-----------------------

To run Fuse standalone:

    sudo docker run jboss-fuse:fuse-standalone

the current shell will then join this process and show the current logs etc.

To run it detatched use:

    sudo docker run -d jboss-fuse:fuse-standalone

e.g. to startup 5 Fuse instances; each will get their own IP address etc:

    sudo docker run -d jboss-fuse:fuse-standalone
    sudo docker run -d jboss-fuse:fuse-standalone
    sudo docker run -d jboss-fuse:fuse-standalone
    sudo docker run -d jboss-fuse:fuse-standalone
    sudo docker run -d jboss-fuse:fuse-standalone
    
You can then run **docker attach** or **docker logs** to get the logs at any time.

In another shell you can run **docker ps** to see all the running containers or **docker inspect $containerID** to view the IP address and details of a container
    
    
Experimenting
-------------

To spin up a shell in one of the containers try:

    sudo docker run -i -t jboss-fuse:java /bin/bash
    sudo docker run -i -t jboss-fuse:fuse /bin/bash

You can then noodle around the container and run stuff & look at files etc.

