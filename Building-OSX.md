Using Docker on OS X
--------------------

If you are working on OS X then please use [dvm]() and the native docker client for OS X.

Here are the [installation instructions](http://hw-ops.com/blog/2014/01/07/introducing-dvm-docker-in-a-box-for-unsupported-platforms/)

You may wish to add this to your ~/.bashrc

    eval $(dvm env)
    
then in any shell you can just run docker commands and they connect correctly to the VM at $DOCKER_HOST

Port forwarding
===============

To be able to access the containers you create in docker from OS X you need to use [port forwarding](http://docs.docker.io/en/latest/use/port_redirection/) when you start a docker container.

However if you are on OS X remember that the port forwarding will be bound to $DOCKER_HOST so connect using that host name and the dynamic bound port or static port you give it.

e.g. if you use a fixed port...

    docker run -p 58181:8181 <img> <cmd>
     
then connect on $DOCKER_HOST:58181. Which tends to be something like http://192.168.42.43:58181/

However if you omit the "58181:" prefix...

    docker run -p 8181 <img> <cmd>

then docker will allocate a port. To find the actual port type

    docker ps
    
and you should see it