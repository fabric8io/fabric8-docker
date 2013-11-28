FROM jboss-fuse:java

#RUN useradd -m fuse

WORKDIR /home/fuse

RUN curl --silent --output fuse-fabric.zip http://repo.fusesource.com/nexus/content/repositories/jboss-fuse-6.1.x/org/fusesource/fabric/fuse-fabric/7.3.0.redhat-182/fuse-fabric-7.3.0.redhat-182.zip
RUN bsdtar -xzf fuse-fabric.zip 
RUN mv fuse-fabric-7.3.0.redhat-182 fuse-fabric
RUN rm fuse-fabric.zip
#RUN chown -R fuse fuse-fabric

WORKDIR /home/fuse/fuse-fabric/etc

# lets add a user - should ideally come from env vars?
RUN echo >> users.properties 
RUN echo admin=admin,admin >> users.properties 

WORKDIR /home/fuse/fuse-fabric

# ensure we have a log file to tail 
RUN mkdir -p data/log
RUN echo >> data/log/karaf.log

EXPOSE 8080 8101 


