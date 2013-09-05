FROM java

RUN useradd -m fuse

WORKDIR /home/fuse

RUN curl --silent --output fuse-fabric.zip http://repo.fusesource.com/nexus/content/repositories/jboss-fuse-6.1.x/org/fusesource/fabric/fuse-fabric/7.3.0.redhat-053/fuse-fabric-7.3.0.redhat-053.zip
RUN bsdtar -xzf fuse-fabric.zip 
RUN mv fuse-fabric-7.3.0.redhat-053 fuse-fabric
RUN rm fuse-fabric.zip
