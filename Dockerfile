FROM debian:stable

RUN apt-get update && apt-get install -y --no-install-recommends procps openjdk-7-jre-headless tar curl && apt-get autoremove -y && apt-get clean

ENV FABRIC8_DISTRO_VERSION 1.2.0.Beta2
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

# create the fabric8 user and group
RUN groupadd -r fabric8 -g 433 && useradd -u 431 -r -g fabric8 -d /opt/fabric8 -s /sbin/nologin -c "fabric8 user" fabric8

RUN mkdir /opt/fabric8-karaf-$FABRIC8_DISTRO_VERSION

RUN cd /opt && curl https://repo1.maven.org/maven2/io/fabric8/fabric8-karaf/$FABRIC8_DISTRO_VERSION/fabric8-karaf-$FABRIC8_DISTRO_VERSION.tar.gz | \
  tar zx && chown -R fabric8:fabric8 /opt/fabric8-karaf-$FABRIC8_DISTRO_VERSION

# Make sure the distribution is available from a well-known place
RUN ln -s /opt/fabric8-karaf-$FABRIC8_DISTRO_VERSION /opt/fabric8 && chown -R fabric8:fabric8 /opt/fabric8

ADD startup.sh /opt/fabric8/startup.sh

# TODO temporary fix for docker issue until 1.2.0.Beta3
ADD jetty.xml /opt/fabric8/fabric/import/fabric/profiles/default.profile/jetty.xml

RUN chown -R fabric8:fabric8 /opt/fabric8 /opt/fabric8/startup.sh /opt/fabric8-karaf-$FABRIC8_DISTRO_VERSION /opt/fabric8-karaf-$FABRIC8_DISTRO_VERSION/*

USER fabric8

WORKDIR /opt/fabric8/etc

# lets remove the karaf.name by default so we can default it from env vars
RUN sed -i '/karaf.name=root/d' system.properties 
RUN sed -i '/runtime.id=/d' system.properties 

RUN echo bind.address=0.0.0.0 >> system.properties
RUN echo fabric.environment=docker >> system.properties
RUN echo zookeeper.password.encode=true >> system.properties

# lets remove the karaf.delay.console=true to disable the progress bar
RUN sed -i 's/karaf.delay.console=true/karaf.delay.console=false/' config.properties 

# lets enable logging to standard out
RUN sed -i 's/log4j.rootLogger=INFO, out, osgi:*/log4j.rootLogger=INFO, stdout, osgi:*/' org.ops4j.pax.logging.cfg

WORKDIR /opt/fabric8

# default values of environment variables supplied by default for child containers created by fabric8
# which have sensible defaults for folks creating new fabrics but can be overloaded when using docker run

#ENV DOCKER_HOST http://172.17.42.1:4243
ENV DOCKER_HOST http://192.168.59.103:2375
ENV FABRIC8_RUNTIME_ID root
ENV FABRIC8_KARAF_NAME root
ENV FABRIC8_BINDADDRESS 0.0.0.0
ENV FABRIC8_PROFILES docker
ENV FABRIC8_HTTP_PORT 8181
ENV FABRIC8_HTTP_PROXY_PORT 8181
ENV FABRIC8_GLOBAL_RESOLVER localip

EXPOSE 1099 2181 8101 8181 9300 9301 44444 61616

CMD /opt/fabric8/startup.sh
