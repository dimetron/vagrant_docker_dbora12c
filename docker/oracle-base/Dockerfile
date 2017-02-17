#Using base image from Oracle
FROM oraclelinux:7.3
MAINTAINER Dmytro Rashko <drashko@me.com>

#to copy proxy settings if any
ADD yum.conf  /etc/yum.conf 

# add extra packages
RUN yum clean all \
 && yum install -y vim-minimal oracle-rdbms-server-12cR1-preinstall \
 && yum clean all

# Define default command.
CMD ["bash"]