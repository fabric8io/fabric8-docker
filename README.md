fuse-dockerfiles
================

Dockerfiles to create Fuse containers in docker.io

Once you have [installed docker](https://www.docker.io/gettingstarted/#h_installation) you should be able to create the containers via:

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
    
    
Docker tips
-----------

To spin up a shell in one of the containers try:

    sudo docker run -i -t java /bin/bash
    sudo docker run -i -t fuse /bin/bash
    
Docker on OS X
--------------

If you are working on OS X you might want to use vagrant to run docker via [these instructions](http://docs.docker.io/en/latest/installation/vagrant/).

    git clone https://github.com/dotcloud/docker.git
    cd docker

Its useful to share a directory between your OS X host operating system and the vagrant vm image. To do this edit the docker/Vagrantfile and add this:


    Vagrant::Config.run do |config|
      # share some files...
      config.vm.network :hostonly, "10.10.10.10"
      config.vm.share_folder("vagrant-root", "/vmshare", "/vmshare")

then create whatever shared directory you want to use:

    sudo mkdir /vmshare

then spin up your docker vm image via vagrant:  

    vagrant up

Then in any shell connect to the docker vm via:

    vagrant ssh

You will then be able to connect to your docker vm via the IP address "10.10.10.10".

To be able to work with the REST API for your docker image you could then kill the docker process and restart it like this:

    /usr/bin/docker -H unix:///var/run/docker.sock -H tcp://10.10.10.10:4243 -d
    
you'll then be able to run the command line stuff as usual as well as connecting over REST via http://10.10.10.10:4243 

e.g. try look at [http://10.10.10.10:4243/images/json](http://10.10.10.10:4243/images/json) for the images.

To make this change on the ubuntu image edit the file **/etc/init/docker.conf**. 

Then use **initctl** to stop/reload/start the docker process.

    initctl reload docker
    initctl start docker
