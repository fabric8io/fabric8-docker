fuse-dockerfiles
================

Dockerfiles to create Fuse containers in docker.io

Once you have [installed docker](https://www.docker.io/gettingstarted/#h_installation) you should be able to create the containers via:

		git clone git@github.com:fusesource/fuse-dockerfiles.git
		cd fuse-dockerfiles
		./build

Then you should have the various containers available to play with: java, fuee etc.

		
Docker tips
-----------

To spin up a shell in one of the containers try:

	  docker run -i -t java /bin/bash
	  docker run -i -t fuse /bin/bash

