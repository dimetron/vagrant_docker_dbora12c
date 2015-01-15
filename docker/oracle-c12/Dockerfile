FROM oracle/java
MAINTAINER Dmytro Rashko <drashko@me.com>

#to copy proxy settings if any
#ADD yum.conf  /etc/yum.conf 

# add extra packages
# RUN yum clean all \
# && yum install -y vim-minimal oracle-rdbms-server-12cR1-preinstall \
# && yum clean all

# create directories
RUN mkdir /opt/oracle /opt/oraInventory /opt/datafile \
 && chown oracle:oinstall -R /opt

# set environment variables
RUN echo "LANG=en_US.utf-8" >> /etc/environment \
 && echo "LC_ALL=en_US.utf-8" >> /etc/environment \
 && echo "export ORACLE_BASE=/opt/oracle" >> /home/oracle/.bash_profile \
 && echo "export ORACLE_HOME=/opt/oracle/product/12.1.0.2/dbhome_1" >> /home/oracle/.bash_profile \
 && echo "export ORACLE_HOME_LISTNER=/opt/oracle/product/12.1.0.2/dbhome_1" >> /home/oracle/.bash_profile \
 && echo "export ORACLE_SID=db12c" >> /home/oracle/.bash_profile \
 && echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bash_profile
 
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 1251