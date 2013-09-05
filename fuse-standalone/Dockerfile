FROM java

RUN useradd -m fuse

WORKDIR /home/fuse

RUN curl --silent --output fuse-fabric.zip http://repo.fusesource.com/nexus/content/repositories/jboss-fuse-6.1.x/org/fusesource/fabric/fuse-fabric/7.3.0.redhat-053/fuse-fabric-7.3.0.redhat-053.zip
RUN bsdtar -xzf fuse-fabric.zip 
RUN mv fuse-fabric-7.3.0.redhat-053 fuse-fabric
RUN rm fuse-fabric.zip

WORKDIR /home/fuse/fuse-fabric/etc

# lets add a user - should ideally come from env vars?
RUN echo >> users.properties 
RUN echo admin=admin,admin >> users.properties 

# lets replace the dodgy 0.0.0.0 hostname
# we should maybe use $HOSTNAME though?
RUN sed -i "s/0\.0\.0\.0/localhost/g" *

WORKDIR /home/fuse/fuse-fabric
