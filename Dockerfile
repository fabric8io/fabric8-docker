FROM centos

# telnet is required by some fabric command. without it you have silent failures
RUN yum install -y java-1.7.0-openjdk which telnet unzip openssh-server sudo openssh-clients
# enable no pass and speed up authentication
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/;s/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

# enabling sudo group
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
# enabling sudo over ssh
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers

ENV JAVA_HOME /usr/lib/jvm/jre

ENV FABRIC8_KARAF_NAME root

# add a user for the application, with sudo permissions
RUN useradd -m fuse ; echo fuse: | chpasswd ; usermod -a -G wheel fuse

# command line goodies
RUN echo "export JAVA_HOME=/usr/lib/jvm/jre" >> /etc/profile
RUN echo "alias ll='ls -l --color=auto'" >> /etc/profile
RUN echo "alias grep='grep --color=auto'" >> /etc/profile


WORKDIR /home/fuse

RUN curl --silent --output fabric8.zip https://repository.jboss.org/nexus/content/groups/ea/io/fabric8/fabric8-karaf/1.0.0.redhat-366/fabric8-karaf-1.0.0.redhat-366.zip
RUN unzip -q fabric8.zip 
RUN mv fabric8-karaf-1.0.0.redhat-366 fabric8
RUN rm fabric8.zip
RUN chown -R fuse:fuse fabric8

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
