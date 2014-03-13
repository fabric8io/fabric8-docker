FROM base

RUN apt-get update
RUN apt-get install -y openjdk-7-jre-headless curl bsdtar

#RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre
ENV FABRIC8_KARAF_NAME root

#RUN useradd -m fuse

WORKDIR /home/fuse

RUN curl --silent --output fabric8.zip https://repository.jboss.org/nexus/content/groups/ea/io/fabric8/fabric8-karaf/1.0.0.redhat-362/fabric8-karaf-1.0.0.redhat-362.zip
RUN bsdtar -xzf fabric8.zip 
RUN mv fabric8-karaf-1.0.0.redhat-362 fabric8
#RUN mv fabric8-karaf-1.0.0-SNAPSHOT fabric8
RUN rm fabric8.zip
#RUN chown -R fuse fabric8

WORKDIR /home/fuse/fabric8/etc

# lets remove the karaf.name by default so we can default it from env vars
RUN sed -i '/karaf.name=root/d' system.properties 

# lets add a user - should ideally come from env vars?
RUN echo >> users.properties 
RUN echo admin=admin,admin >> users.properties 

# lets enable logging to standard out
RUN echo log4j.rootLogger=INFO, stdout, osgi:* >> org.ops4j.pax.logging.cfg 

WORKDIR /home/fuse/fabric8

# ensure we have a log file to tail 
RUN mkdir -p data/log
RUN echo >> data/log/karaf.log

EXPOSE 8181 8101 1099 2181 9300 61616

CMD echo "starting Fabric8 container: $FABRIC8_KARAF_NAME connecting to ZooKeeper: $FABRIC8_ZOOKEEPER_URL" && /home/fuse/fabric8/bin/karaf server


