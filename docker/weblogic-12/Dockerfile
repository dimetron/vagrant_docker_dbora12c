# LICENSE CDDL 1.0 + GPL 2.0
#
# Modified from 
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for WebLogic 12.1.3 (Full) Generic Distribution
# 
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) fmw_12.1.3.0.0_wls.jar
#     Download the Generic installer from http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html
#
# (2) jdk-7u25-linux-x64.rpm
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#     cp /etc/yum.conf /vagrant/docker/weblogic-12/
#     sudo docker build --no-cache -t="oracle/weblogic12" /vagrant/docker/weblogic-12/
#

#Using base image from Oracle
FROM oracle/java
MAINTAINER Dmytro Rashko <drashko@me.com>

#to copy proxy settings if any
ADD yum.conf  /etc/yum.conf 

ENV WLS_PKG  fmw_12.1.3.0.0_wls.jar
# WLS Admin Password (you may change)
# This password is used for:
#  (a) 'weblogic' Linux user in this image
# -----------------------------------
ENV ADMIN_USER weblogic
ENV ADMIN_PASSWORD weblogic

ENV BASE_HOME /home
ENV INST /opt

# Setup required packages (unzip), filesystem, and crm92 user
# ------------------------------------------------------------
RUN useradd -b $BASE_HOME -m -s /bin/bash $ADMIN_USER \
 && mkdir $INST -p \
 && chmod a+xr $INST \ 
 && mkdir $INST/.inventory \
 && echo  $ADMIN_USER:$ADMIN_PASSWORD | chpasswd

#copy weblogic install package
COPY $WLS_PKG $INST/

# Adjust file permissions, go to /u01 as user '$ADMIN_USER' to proceed with WLS installation
RUN chown $ADMIN_USER:$ADMIN_USER -R $INST

USER $ADMIN_USER
WORKDIR $INST

#create .inventory file
RUN echo -e "inventory_loc=$INST/.inventory" 	> oraInst.loc    \
 && echo -e "\ninst_group=$ADMIN_USER" 		 	>> oraInst.loc   \
 && echo -e "[ENGINE]" 				    		> install.file   \
 && echo -e "\nResponse File Version=1.0.0.0.0" >> install.file  \
 && echo -e "\n[GENERIC]" 					    >> install.file  \
 && echo -e "\nORACLE_HOME=$INST/$ADMIN_USER"   >> install.file  \
 && echo -e "\nINSTALL_TYPE=WebLogic Server"    >> install.file  \
 && echo -e "\nMYORACLESUPPORT_USERNAME="    	>> install.file  \
 && echo -e "\nMYORACLESUPPORT_PASSWORD="    	>> install.file  \
 && echo -e "\nDECLINE_SECURITY_UPDATES=true"   >> install.file  \
 && echo -e "\nSECURITY_UPDATES_VIA_MYORACLESUPPORT=false"    >> install.file  \
 && echo -e "\nPROXY_HOST="    				 	>> install.file  \
 && echo -e "\nPROXY_PORT="    				 	>> install.file  \
 && echo -e "\nPROXY_USER="    				 	>> install.file  \
 && echo -e "\nPROXY_PWD="    				 	>> install.file  \
 && echo -e "\nCOLLECTOR_SUPPORTHUB_URL="    	>> install.file  \
 && cat install.file 

# Installation of WebLogic 
RUN java -jar $WLS_PKG -silent -responseFile $INST/install.file -invPtrLoc $INST/oraInst.loc -jreLoc $JAVA_HOME \
 && rm $WLS_PKG $INST/oraInst.loc $INST/install.file

WORKDIR $BASE_HOME/$ADMIN_USER

# Define default command to start bash. 
CMD ["/bin/bash"]

