#!/bin/bash
# --------------------------------------------------------------------- #
# Date:         20191127                                    			#
# Script:       OpenVAS11-Debian10-Install-Script.sh			       	#
#                                                        				#
# Description:  Installs OpenVAS 11 on Debian 10            			#
#                                                        				#
# Work in progress                                         				#
# --------------------------------------------------------------------- #

# Install files
# https://community.greenbone.net/t/gvm-11-stable-initial-release-2019-10-14/3674
GVMLIBS_URL="https://github.com/greenbone/gvm-libs/archive/v11.0.0.tar.gz"
OPENVAS_URL="https://github.com/greenbone/openvas/archive/v7.0.0.tar.gz"
OSPD2_URL="https://github.com/greenbone/ospd/archive/v2.0.0.tar.gz"
OSPD1_URL="https://github.com/greenbone/ospd-openvas/archive/v1.0.0.tar.gz"
GVMD_URL="https://github.com/greenbone/gvmd/archive/v9.0.0.tar.gz"
GSA_URL="https://github.com/greenbone/gsa/archive/v9.0.0.tar.gz"
PGVM_URL="https://github.com/greenbone/python-gvm/archive/v1.0.0.tar.gz"
GVMTOOLS_URL="https://github.com/greenbone/gvm-tools/archive/v2.0.0.tar.gz"
OPENVASSMB_URL="https://github.com/greenbone/openvas-smb/archive/v1.0.5.tar.gz"

# --------------------------------------------------------------------- #
# check if we run Debian 10
# --------------------------------------------------------------------- #
OSVERSION=`cat /etc/debian_version`
if [[ $OSVERSION =~ .*'10.'.* ]]; then
  echo "Good you are running Debian 10"
else
  echo "ERROR: You are not running Debian 10"
  echo "ERROR: Unsupported system, stopping now"
  echo "^^^^^^^^^^ SCRIPT ABORTED ^^^^^^^^^^"
  exit 1
fi
# --------------------------------------------------------------------- #


mkdir /tmp/gvm11

