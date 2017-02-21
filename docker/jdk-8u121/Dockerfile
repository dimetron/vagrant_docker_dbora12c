#Using base image from Oracle
FROM oraclelinux:7-slim
MAINTAINER Dmytro Rashko <drashko@me.com>

## Environment variables required for this build (do NOT change)
ENV JAVA_RPM jdk-8u121-linux-x64.rpm

#to copy proxy settings if any
ADD yum.conf  /etc/yum.conf 

#Install OpenJDK with all  dependencies
RUN echo "Installing dependencies" \ 
	&& yum -y install vim-minimal wget unzip ksh hostname ping \ 
	&& yum -y clean all \ 
	&& rm -rf /var/lib/{cache,log} /var/log/lastlog

# Install gosu
RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64' \
    && chmod +x /usr/local/bin/gosu

# Install and configure Oracle JDK 8u121
# -------------------------------------
COPY $JAVA_RPM /opt/
RUN rpm -Uhv /opt/$JAVA_RPM && rm -rf /opt/$JAVA_RPM && rm -rf /usr/java/jdk1.8.0_121/*src.zip /usr/java/jdk1.8.0_121/lib/missioncontrol  

ENV JAVA_HOME /usr/java/default
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Define default command.
CMD ["bash"]