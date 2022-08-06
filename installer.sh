#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL XSTREAMITY
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/emil237/xtreamity/main/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERSION='3.70'
PACKAGE='enigma2-plugin-extensions-xstreamity'
MY_URL='https://raw.githubusercontent.com/emil237/xtreamity/main'

####################
#  Image Checking  #
if which opkg > /dev/null 2>&1; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    PKGEXP3='exteplayer3'
    PKGGPLY='gstplayer'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGREMOV='opkg remove --force-depends'
else
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    PKGBAPP='gstreamer1.0-plugins-base-apps'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

######################
#  Remove Old Plugin #
if grep -qs "Package: $PACKAGE" $STATUS ; then
    echo "   >>>>   Remove old version   <<<<"
    if [ $OSTYPE = "Opensource" ]; then
        $OPKGREMOV $PACKAGE
        echo ""
        sleep 2; clear
    else
        $OPKGREMOV $PACKAGE
        echo ""
        sleep 2; clear
    fi
else
    echo "   >>>>   No Older Version Was Found   <<<<"
    sleep 1
    echo ""; clear
fi

#####################
# Package Checking  #
if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PKGEXP3" $STATUS ; then
        echo "$PKGEXP3 found in device..."
        sleep 1; clear
    else
        echo "Need to install $PKGEXP3"
        echo
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading $PKGEXP3 ......"
        echo
        $OPKGINSTAL $PKGEXP3
        sleep 1; clear
    fi
    if grep -qs "Package: $PKGGPLY" $STATUS ; then
        echo "$PKGGPLY found in device..."
        sleep 1; clear
    else
        echo "Need to install $PKGGPLY"
        echo
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading $PKGGPLY ......"
        echo
        $OPKGINSTAL $PKGGPLY
        sleep 1; clear
    fi

elif [ $OSTYPE = "DreamOS" ]; then
    if grep -qs "Package: $PKGBAPP" $STATUS ; then
        echo " $PKGBAPP found in device..."
        sleep 1; clear
    else
        echo "Need to install  $PKGBAPP"
        echo
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading  $PKGBAPP ......"
        echo
        $OPKGINSTAL  $PKGBAPP -y
        sleep 1; clear
    fi
fi

if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PKGEXP3" $STATUS ; then
        echo
    else
        echo "Feed Missing $PKGEXP3"
        echo "Sorry, the plugin will not be install"
        exit 1
    fi
    if grep -qs "Package: $PKGGPLY" $STATUS ; then
        echo
    else
        echo "Feed Missing $PKGGPLY"
        echo "Sorry, the plugin will not be install"
        exit 1
    fi
elif [ $OSTYPE = "DreamOS" ]; then
    if grep -qs "Package: $PKGBAPP" $STATUS ; then
        echo
    else
        echo "Feed Missing $PKGBAPP"
        echo "Sorry, the plugin will not be install"
        exit 1
    fi
fi
###################
#  Install Plugin #
if [ $OSTYPE = "Opensource" ]; then
    echo "Insallling xstreamity plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
else
    echo "Insallling xstreamity plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_${VERSION}.deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE}_${VERSION}.deb; $OPKGINSTAL -f -y 
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

sleep 1; clear
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**       xstreamity : $VERSION                             *"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "   
sleep 4;
		echo ". >>>>         RESTARING     <<<<"
echo "**********************************************************************************"
echo ""

if [ $OSTYPE = "Opensource" ]; then
    killall -9 enigma2
else
    systemctl restart enigma2
fi

exit 0
