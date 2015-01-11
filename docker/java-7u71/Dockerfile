#Using base image from Oracle
FROM oraclelinux:6.6
MAINTAINER Dmytro Rashko <drashko@me.com>

#to copy proxy settings if any
ADD yum.conf  /etc/yum.conf 

# add extra packages
RUN yum clean all \
 && yum install -y vim-minimal oracle-rdbms-server-12cR1-preinstall \
 && yum clean all

# Environment variables required for this build (do NOT change)
ENV JAVA_RPM jdk-7u71-linux-x64.rpm

# Install and configure Oracle JDK 7u71
# -------------------------------------
COPY $JAVA_RPM /opt/
RUN rpm -ivh /opt/$JAVA_RPM && rm -rf /opt/$JAVA_RPM

ENV JAVA_HOME /usr/java/default
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Define default command.
CMD ["bash"]