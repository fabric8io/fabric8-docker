FROM fedora

# telnet is required by some fabric command. without it you have silent failures
RUN yum install -y java-1.7.0-openjdk unzip

#set the fabric8 version env variable
ENV FABRIC8_DISTRO_VERSION 1.2.0.Beta2

# Clean the metadata
RUN yum clean all

ENV JAVA_HOME /usr/lib/jvm/jre

ENV FABRIC8_RUNTIME_ID root
ENV FABRIC8_KARAF_NAME root
ENV FABRIC8_BINDADDRESS 0.0.0.0
ENV FABRIC8_PROFILES docker

# add a user for the application, with sudo permissions
RUN useradd -m fabric8 ; echo fabric8: | chpasswd ; usermod -a -G wheel fabric8

# command line goodies
RUN echo "export JAVA_HOME=/usr/lib/jvm/jre" >> /etc/profile
RUN echo "alias ll='ls -l --color=auto'" >> /etc/profile
RUN echo "alias grep='grep --color=auto'" >> /etc/profile


WORKDIR /home/fabric8

ADD startup.sh /home/fabric8/startup.sh
RUN chmod +x startup.sh

USER fabric8

# temporarily use the jboss nexus while the release syncs
RUN curl --silent --output fabric8.zip http://central.maven.org/maven2/io/fabric8/fabric8-karaf/$FABRIC8_DISTRO_VERSION/fabric8-karaf-$FABRIC8_DISTRO_VERSION.zip
RUN unzip -q fabric8.zip 
RUN ls -al
RUN mv fabric8-karaf-$FABRIC8_DISTRO_VERSION fabric8-karaf
RUN rm fabric8.zip
#RUN chown -R fabric8:fabric8 fabric8-karaf

# temporary fix for docker issue until 1.2.0.Beta3
ADD jetty.xml /home/fabric8/fabric8-karaf/fabric/import/fabric/profiles/default.profile/jetty.xml

WORKDIR /home/fabric8/fabric8-karaf/etc

# lets remove the karaf.name by default so we can default it from env vars
RUN sed -i '/karaf.name=root/d' system.properties 
RUN sed -i '/runtime.id=/d' system.properties 

RUN echo bind.address=0.0.0.0 >> system.properties
RUN echo fabric.environment=docker >> system.properties
RUN echo zookeeper.password.encode=true >> system.properties

# lets remove the karaf.delay.console=true to disable the progress bar
RUN sed -i '/karaf.delay.console=true/d' config.properties 
RUN echo karaf.delay.console=false >> config.properties

# lets add a user - should ideally come from env vars?
RUN echo >> users.properties 
RUN echo admin=admin,admin >> users.properties 

# lets enable logging to standard out
RUN echo log4j.rootLogger=INFO, stdout, osgi:* >> org.ops4j.pax.logging.cfg 

WORKDIR /home/fabric8/fabric8-karaf

# ensure we have a log file to tail 
RUN mkdir -p data/log
RUN echo >> data/log/karaf.log

WORKDIR /home/fabric8

EXPOSE 1099 2181 8101 8181 9300 9301 44444 61616 

USER root

CMD /home/fabric8/startup.sh
