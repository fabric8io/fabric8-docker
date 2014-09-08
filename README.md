fabric8-docker
==============

This project builds a [docker](http://docker.io/) container for running [fabric8](http://fabric8.io/)

Try it out
----------

If you have docker installed you should be able to try it out via

    docker pull fabric8/fabric8
    docker run -Pit -e DOCKER_HOST=http://192.168.59.103:2375 fabric8/fabric8

Where the value of DOCKER_HOST should be the URL (ideally http) where the docker container can access the [Docker Remote API](https://docs.docker.com/reference/api/docker_remote_api/) to be able to create/start/stop containers in docker.

You can pass in various [environment variables](http://fabric8.io/gitbook/environmentVariables.html) to customise how a fabric is created or joined; or specify stand alone mode if required etc.

In addition, the Docker image allows you to override a few other things through environment variables:

* `ADMIN_USERNAME`: the admin username you can use to connect to the Karaf shell as & authenticate to HawtIO (default: `admin`)
* `ADMIN_PASSWORD`: the admin password to use (default: `admin`)
* `DOCKER_HOST`: the URI to the Docker REST endpoint. This is necessary if you want to manage Docker containers from your Docker container :) (default: `tcp://172.17.42.1:4243`)

You can then run **docker attach** or **docker logs** to get the logs at any time.

Run  **docker ps** to see all the running containers or **docker inspect $containerID** to view the IP address and details of a container


Known issues
------------

* there is a [known issue](https://github.com/boot2docker/boot2docker/issues/527) with the use of boot2docker where permissions are not setup correctly so the fabric8 cannot startup. Works fine on linux though!
* DOCKER_HOST must point to a TCP / HTTP endpoint for now; we don't yet support using unix sockets to communicate with the Docker REST API.

Using the interactive shell
---------------------------

If you want to run the docker container a bit more like running the bin/fabric8 command where you get an interactive colourful ssh shell on the command line then try this:

    docker run -Pit fabric8/fabric8 /home/fabric8/fabric8-karaf/bin/fabric8

Accessing the web console
-------------------------

Find the port that 8181 is exposed from the container to the host via 

    docker ps
    
and looking for the text 4XXXX->8181 then find the correct value of 4XXXX. 

Then open a browser at **http://$HOST:4XXX** using the correct value of HOST. If you are on linux then this can be **localhost** or if you use boot2docker then its the IP adress output via

    boot2docker ip
     
You should now see the fabric8 web console from which you can browse the git repository, running containers and create new containers.

Creating new containers (like Java Containers, Spring Boot, Tomcat, Jetty etc) creates a new docker image on the fly based on the profile metadata and deployment units then starts it up using the Docker Remote API.


Building the docker container locally
-------------------------------------

We have a Docker Index trusted build setup to automatically rebuild the fabric8/fabric8 container whenever the [Dockerfile](https://github.com/fabric8io/fabric8-docker/blob/master/Dockerfile) is updated, so you shouldn't have to rebuild it locally. But if you want to, here's now to do it...

Once you have [installed docker](https://www.docker.io/gettingstarted/#h_installation) you should be able to create the containers via the following:

If you are on OS X then see [How to use Docker on OS X](DockerOnOSX.md).

    git clone git@github.com:fabric8io/fabric8-docker.git
    cd fabric8-docker
    ./build.sh

The fabric8 container should then build.

Using a local build
-------------------

To create a fabric8 using your local build try the following:

    docker run -Pit -e DOCKER_HOST=http://192.168.59.103:2375 -e FABRIC8_DOCKER_IMAGE_FABRIC8=fabric8:fabric8 fabric8:fabric8

This will then startup your locally built image fabric8:fabric8 and then use that image when creating any new karaf based containers via the CLI or web console.

Experimenting
-------------

To spin up a shell in one of the containers try:

    docker run -Pit fabric8/fabric8 /bin/bash

You can then noodle around the container and run stuff & look at files etc.


Docker resources
----------------

* If you are on OS X then see the [How to use Docker on OS X The Missing Guide](http://viget.com/extend/how-to-use-docker-on-os-x-the-missing-guide) and [How to use Docker on OS X](DockerOnOSX.md).
* Until docker exec is supported; you should look at using nsenter to get a shell inside a container instance. Check out this [awesome blog](http://ro14nd.de/NSEnter-with-Boot2Docker/) on how to do that.

