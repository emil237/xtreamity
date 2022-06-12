#!/bin/sh

##setup command=wget https://raw.githubusercontent.com/emil237/xtreamity/main/installer.sh -O - | /bin/sh
#
echo " download and install plugin xstreamity "
################################################################################
version=3.68
OPKGINSTALL=opkg install --force-overwrite
MY_URL="https://raw.githubusercontent.com/emil237/xtreamity/main"
MY_IPK="xstreamity_3.68_all.ipk"
MY_DEB="xstreamity_3.68_all.deb"
##############################################################################
# remove old plugin #
opkg remove enigma2-plugin-extensions-xstreamity

rm -rf /usr/lib/enigma2/python/Plugins/Extensions/XStreamity/

echo "Ok Removed Old Plugin"

#################################################################################

# Download and install plugin #
echo " DOWNLOAD AND INSTALL PLUGIN "
cd /tmp 
rm -rf * > /dev/null 2>&1
set -e
     wget "$MY_URL/$MY_IPK"
  wait
     wget "$MY_URL/$MY_DEB"

 if which dpkg > /dev/null 2>&1; then
		dpkg -i --force-overwrite $MY_DEB; apt-get install -f -y
	else
		opkg install --force-overwrite $MY_IPK
	fi
echo "==========================================================================================================================="
set +e
cd ..
wait
rm -f /tmp/$MY_IPK
rm -f /tmp/$MY_DEB
	if [ $? -eq 0 ]; then
echo ">>>>  SUCCESSFULLY INSTALLED <<<<"
fi
		echo "********************************************************************************"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "   
sleep 4;
		echo ". >>>>         RESTARING     <<<<"
echo "**********************************************************************************"
wait
killall -9 enigma2
exit 0



















































































