fabric8-docker
==============

This project builds a [docker](http://docker.io/) container for running [fabric8](http://fabric8.io/)

Try it out
----------

If you have docker installed you should be able to try it out via

    docker run -P -dt -e DOCKER_HOST=http://192.168.59.103:2375 fabric8/fabric8

Where the value of DOCKER_HOST should be the URL (ideally http) where the docker container can access the [Docker Remote API](https://docs.docker.com/reference/api/docker_remote_api/) to be able to create/start/stop containers in docker.

You can pass in various [environment variables](http://fabric8.io/gitbook/environmentVariables.html) to customise how a fabric is created or joined; or specify stand alone mode if required etc.

In addition, the Docker image allows you to override a few other things through environment variables:

* `ADMIN_USERNAME`: the admin username you can use to connect to the Karaf shell as & authenticate to HawtIO (default: `admin`)
* `ADMIN_PASSWORD`: the admin password to use (default: `admin`)
* `DOCKER_HOST`: the URI to the Docker REST endpoint. This is necessary if you want to manage Docker containers from your Docker container :) (default: `tcp://172.17.42.1:4243`)

You can then run **docker attach** or **docker logs** to get the logs at any time.

Run  **docker ps** to see all the running containers or **docker inspect $containerID** to view the IP address and details of a container


Using the interactive shell
---------------------------

If you want to run the docker container a bit more like running the bin/fabric8 command where you get an interactive colourful ssh shell on the command line then try this:

    docker run -P -it fabric8/fabric8 /home/fabric8/fabric8-karaf/bin/fabric8

Building the docker container locally
-------------------------------------

We have a Docker Index trusted build setup to automatically rebuild the fabric8/fabric8 container whenever the [Dockerfile](https://github.com/fabric8io/fabric8-docker/blob/master/Dockerfile) is updated, so you shouldn't have to rebuild it locally. But if you want to, here's now to do it...

Once you have [installed docker](https://www.docker.io/gettingstarted/#h_installation) you should be able to create the containers via the following:

If you are on OS X then see [How to use Docker on OS X](DockerOnOSX.md).

    git clone git@github.com:fabric8io/fabric8-docker.git
    cd fabric8-docker
    ./build.sh

The fabric8 container should then build.

Experimenting
-------------

To spin up a shell in one of the containers try:

    docker run -P -it fabric8/fabric8 /bin/bash

You can then noodle around the container and run stuff & look at files etc.


Docker resources
----------------

* If you are on OS X then see the [How to use Docker on OS X The Missing Guide](http://viget.com/extend/how-to-use-docker-on-os-x-the-missing-guide) and [How to use Docker on OS X](DockerOnOSX.md).
* Until docker exec is supported; you should look at using nsenter to get a shell inside a container instance. Check out this [awesome blog](http://ro14nd.de/NSEnter-with-Boot2Docker/) on how to do that.

