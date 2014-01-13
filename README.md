fabric8-dockerfiles
===================

Dockerfiles to create [fabric8](http://fabric8.io/) containers in [docker.io](http://docker.io/)

Once you have [installed docker](https://www.docker.io/gettingstarted/#h_installation) you should be able to create the containers via the following:

If you are on OS X then see the [Building-OSX.md](https://github.com/jboss-fuse/fuse-dockerfiles/blob/master/Building-OSX.md#using-docker-on-os-x) document.

    git clone git@github.com:fusesource/fabric8-dockerfiles.git
    cd fabric8-dockerfiles
    ./build

Then you should have the various containers available to play with: java, fuee etc.


Images
------

* **java**: creates a container which has a JVM installed with JAVA_HOME set etc
* **fabric8**: installs a fabric8 distro into /home/fuse/fabric7
    
    
Running Fabric8
---------------

To run a fabric8 container:

    docker run -p 8181 fabric8:fabric8

the current shell will then join this process and show the current logs etc.

To run it detatched use:

    docker run -d -p 8181 fabric8:fabric8

e.g. to startup 5 Fabric8 instances; each will get their own IP address etc:

    docker run -d -p 8181 fabric8:fabric8
    docker run -d -p 8181 fabric8:fabric8
    docker run -d -p 8181 fabric8:fabric8
    docker run -d -p 8181 fabric8:fabric8
    docker run -d -p 8181 fabric8:fabric8
    
You can then run **docker attach** or **docker logs** to get the logs at any time.

In another shell you can run **docker ps** to see all the running containers or **docker inspect $containerID** to view the IP address and details of a container
    
    
Experimenting
-------------

To spin up a shell in one of the containers try:

    docker run -p 8181 -i -t fabric8:fabric8 /bin/bash

You can then noodle around the container and run stuff & look at files etc.



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fabric8io/fabric8-dockerfiles/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

