FROM oracle/jdk-8u121
MAINTAINER Dmytro Rashko <drashko@me.com>

ADD yum.conf  /etc/yum.conf 

ENV WLS_PKG  fmw_12.1.3.0.0_wls.jar
ENV JAVA_HOME /usr/java/default
ENV ADMIN_USER weblogic
ENV ADMIN_PASSWORD weblogic
ENV BASE_HOME /home
ENV INST /opt
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Setup required packages (unzip), filesystem, and crm92 user
# ------------------------------------------------------------
RUN useradd -b $BASE_HOME -m -s /bin/bash $ADMIN_USER \
 && mkdir $INST -p && chmod a+xr $INST \ 
 && mkdir $INST/.inventory \
 && echo  $ADMIN_USER:$ADMIN_PASSWORD | chpasswd

COPY $WLS_PKG $INST/
RUN chown $ADMIN_USER:$ADMIN_USER -R $INST

USER $ADMIN_USER
WORKDIR $INST

RUN echo -e "inventory_loc=$INST/.inventory" 	> oraInst.loc    \
 && echo -e "\ninst_group=$ADMIN_USER" 		 	>> oraInst.loc   

RUN echo -e "[ENGINE]" 				    		> install.file   \
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
RUN java -jar $WLS_PKG -silent -responseFile $INST/install.file -invPtrLoc $INST/oraInst.loc -jreLoc $JAVA_HOME

USER root
RUN ln -s /opt/weblogic/oracle_common/modules/org.apache.maven_3.0.5/bin/mvn /usr/bin/mvn
RUN cd $INST && rm $WLS_PKG oraInst.loc install.file

USER $ADMIN_USER
WORKDIR $BASE_HOME/$ADMIN_USER
CMD ["/bin/bash"]