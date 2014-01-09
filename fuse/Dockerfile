FROM jboss-fuse:java

#RUN useradd -m fuse

WORKDIR /home/fuse

RUN curl --silent --output fabric8.zip https://repository.jboss.org/nexus/content/groups/ea/io/fabric8/fuse-fabric/1.0.0.redhat-312/fuse-fabric-1.0.0.redhat-312.zip
RUN bsdtar -xzf fabric8.zip 
RUN mv fuse-fabric-1.0.0.redhat-312 fabric8
RUN rm fabric8.zip
#RUN chown -R fuse fabric8

WORKDIR /home/fuse/fabric8/etc

# lets add a user - should ideally come from env vars?
RUN echo >> users.properties 
RUN echo admin=admin,admin >> users.properties 

WORKDIR /home/fuse/fabric8

# ensure we have a log file to tail 
RUN mkdir -p data/log
RUN echo >> data/log/karaf.log

EXPOSE 8181 8101 


