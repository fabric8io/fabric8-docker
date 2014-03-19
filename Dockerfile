FROM base

RUN apt-get -q -y update
RUN apt-get -q -y install openssh-server openjdk-7-jre-headless curl bsdtar

#RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre
ENV FABRIC8_KARAF_NAME root

#RUN useradd -m fuse

# setup sshd capability
RUN mkdir /var/run/sshd 
RUN echo 'root:tcuser' |chpasswd

RUN cat /root/.profile | grep mesg
RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile
RUN cat /root/.profile | grep mesg


WORKDIR /home/fuse

RUN curl --silent --output fabric8.zip https://repository.jboss.org/nexus/content/groups/ea/io/fabric8/fabric8-karaf/1.0.0.redhat-366/fabric8-karaf-1.0.0.redhat-366.zip
RUN bsdtar -xzf fabric8.zip 
RUN mv fabric8-karaf-1.0.0.redhat-366 fabric8
RUN rm fabric8.zip
#RUN chown -R fuse fabric8

WORKDIR /home/fuse/fabric8/etc

# lets remove the karaf.name by default so we can default it from env vars
RUN sed -i '/karaf.name=root/d' system.properties 

RUN echo bind.address=127.0.0.1 >> system.properties
RUN echo fabric.environment=docker >> system.properties

# lets remove the karaf.delay.console=true to disable the progress bar
RUN sed -i '/karaf.delay.console=true/d' config.properties 
RUN echo karaf.delay.console=false >> config.properties

# lets add a user - should ideally come from env vars?
RUN echo >> users.properties 
RUN echo admin=admin,admin >> users.properties 

# lets enable logging to standard out
RUN echo log4j.rootLogger=INFO, stdout, osgi:* >> org.ops4j.pax.logging.cfg 

WORKDIR /home/fuse/fabric8

# ensure we have a log file to tail 
RUN mkdir -p data/log
RUN echo >> data/log/karaf.log

RUN curl --silent --output startup.sh https://raw.github.com/fabric8io/fabric8-docker/master/startup.sh
RUN chmod +x startup.sh

EXPOSE 22 1099 2181 8181 8101 1099 9300 9301 44444 61616 

CMD /home/fuse/fabric8/startup.sh
