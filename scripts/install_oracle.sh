#/bin/sh

echo "----------------------------------------------------------"
echo "# Step 1 of 5 - This script will install oracle database  "
echo "----------------------------------------------------------"

#moving oracle temp files out of VM
su - oracle -c "cp /home/oracle/.bash_profile /home/oracle/.bash_profile.old"
su - oracle -c "echo export TMPDIR=/vagrant/tmp >> /home/oracle/.bash_profile"
su - oracle -c "echo export TEMP=/vagrant/tmp >> /home/oracle/.bash_profile" 
su - oracle -c "echo export TMP=/vagrant/tmp >> /home/oracle/.bash_profile" 
su - oracle -c "/vagrant/database/runInstaller -silent -logLevel error -waitforcompletion -showProgress -ignorePrereq -responseFile /vagrant/docker/oracle-c12/db_install.rsp SECURITY_UPDATES_VIA_MYORACLESUPPORT=false DECLINE_SECURITY_UPDATES=true"
su - oracle -c "mv /home/oracle/.bash_profile.old /home/oracle/.bash_profile"

echo "----------------------------------------------------------"
echo "# Step 2 of 5 - Configure oracle environment settings     "
echo "----------------------------------------------------------"
/opt/oraInventory/orainstRoot.sh
/opt/oracle/product/12.1.0.2/dbhome_1/root.sh

echo "----------------------------------------------------------"
echo "# Step 3 of 5 - Installing Listener ... 				  "
echo "----------------------------------------------------------"
su - oracle -c "netca -silent -responseFile /opt/oracle/product/12.1.0.2/dbhome_1/assistants/netca/netca.rsp"
su - oracle -c "\$ORACLE_HOME/bin/lsnrctl start"

echo "----------------------------------------------------------"
echo "# Step 4 of 5 - Installing Database ... 				  "
echo "----------------------------------------------------------"
#su - oracle -c "dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbname db12c -sid db12c -responseFile NO_VALUE -characterSet AL32UTF8 -memoryPercentage 50 -emConfiguration LOCAL"
su - oracle -c "dbca -silent -createDatabase -responseFile /vagrant/docker/oracle-c12/dbca.rsp"


echo "----------------------------------------------------------"
echo "# Step 5 of 5 - Installing service scripts ... 			  "
echo "----------------------------------------------------------"
sed -i s/dbhome_1:N/dbhome_1:Y/g /etc/oratab
cp /vagrant/docker/oracle-c12/dbstart /etc/init.d/
chmod +x /etc/init.d/dbstart
chkconfig dbstart on
service dbstart stop

echo "----------------------------------------------------------"
echo "# Verify oracle DB start / stop								"
echo "----------------------------------------------------------"
service dbstart start
service dbstart stop

echo "----------------------------------------------------------"
echo "# Installation complete  									"
echo "----------------------------------------------------------"
exit