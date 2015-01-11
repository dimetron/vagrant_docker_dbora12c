#/bin/sh

echo "----------------------------------------------------------"
echo "# Step 1 of 5 - This script will install oracle database  "
echo "----------------------------------------------------------"

#mkdir /vagrant/tmp
#
su - oracle -c "cp /home/oracle/.bash_profile /home/oracle/.bash_profile.old"

#moving oracle temp files out of VM
su - oracle -c "echo export TMPDIR=/vagrant/tmp >> /home/oracle/.bash_profile"
su - oracle -c "echo export TEMP=/vagrant/tmp >> /home/oracle/.bash_profile" 
su - oracle -c "echo export TMP=/vagrant/tmp >> /home/oracle/.bash_profile" 

su - oracle -c "/vagrant/database/runInstaller -silent -waitforcompletion -showProgress -ignorePrereq -responseFile /vagrant/docker/oracle-c12/db_install.rsp"

#restore orig ENV settings
su - oracle -c "mv /home/oracle/.bash_profile.old /home/oracle/.bash_profile"

#post installation setup
echo "----------------------------------------------------------"
echo "# Step 2 of 5 - Configure oracle environment settings     "
echo "----------------------------------------------------------"

/opt/oraInventory/orainstRoot.sh
/opt/oracle/product/12.1.0.2/dbhome_1/root.sh

#install listener
echo "----------------------------------------------------------"
echo "# Step 3 of 5 - Installing Listener ... 				  "
echo "----------------------------------------------------------"

su - oracle -c "netca -silent -responseFile /opt/oracle/product/12.1.0.2/dbhome_1/assistants/netca/netca.rsp"
su - oracle -c "\$ORACLE_HOME/bin/lsnrctl start"

#install database
echo "----------------------------------------------------------"
echo "# Step 4 of 5 - Installing Database ... 				  "
echo "----------------------------------------------------------"

su - oracle -c "dbca -silent -createDatabase -responseFile /vagrant/docker/oracle-c12/dbca.rsp"

#install service scripts
echo "----------------------------------------------------------"
echo "# Step 5 of 5 - Installing service scripts ... 			  "
echo "----------------------------------------------------------"

#install oracle service script
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

