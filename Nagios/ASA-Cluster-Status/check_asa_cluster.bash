#!/bin/bash
# --------------------------------------------------------------------- #
# Date:         20160719                                      			    #
# Script:       check_asa_cluster.bash & check_asa_cluster.exp          #
#                                                        				        #
# Description:  Check the status of an ASA Cluster            			    #
#               Script uses SSH to login as user, which means the user  #
#               account needs level 15 privileges to request the        #
#               cluster status information                    			    #
#                                                        				        #
# Usage:        -H <IP> -U <USER> -P <PASS> -M <MODE>         			    #
# --------------------------------------------------------------------- #

# ---------------------------------- #
# Variables
# ---------------------------------- #
usage="Usage: -H hostname -U user -P pass -M mode
-H Hostname
-U SSH User
-P SSH Password
-M Mode 0 = Master, 1 = Slave
-h Help (print help message)"

tmp_file="/tmp/check_asa_cluster.tmp"

# ---------------------------------- #
# Check parameters
# ---------------------------------- #
check_options()
{
if [ "$hostname" == "" ] || [ "$username" == "" ] || [ "$password" == "" ] || [ "$mode" == "" ]; then
  echo "Error - Missing parameters:"
  echo "hostname = $hostname"
  echo "username = $username"
  echo "password = $password"
  echo "mode     = $mode"
  echo ""
  echo "$usage"
  function_exit
fi

if [ "$mode" == "0" ]; then mode=MASTER
elif [ "$mode" == "1" ]; then mode=SLAVE
else
  echo "ERROR: Invalid Mode"
  echo "$usage"
  function_exit
fi
}

# ---------------------------------- #
# check the ASA cluster status
# ---------------------------------- #
check_cluster()
{
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/check_asa_cluster.exp $hostname $username $password >> $tmp_file
dos2unix $tmp_file >> /dev/null 2>&1

# Check if clustering is enabled on this host:
CL_STATUS="`cat $tmp_file | grep Cluster | sed 's/.*: //'`"
if [ "$CL_STATUS" == "On" ]; then
  # Check if this host matches its mode
  CL_UNIT_MODE="`cat $tmp_file | grep "This is" | sed 's/.*state //'`"
  if [ "$CL_UNIT_MODE" == "$mode" ]; then
     RESULT_LOG="Clustering enabled and mode is $CL_UNIT_MODE"
     RESULT="OK"
  else
   RESULT_LOG="ERROR: Clustering enabled but mode is $CL_UNIT_MODE instead of $mode"
   RESULT="CRITICAL"
  fi
else
 RESULT_LOG="ERROR: Clustering not enabled"
 RESULT="CRITICAL"
fi

#clean up the tmp file
rm $tmp_file
}
# ---------------------------------- #
# Results sent to Nagios
# ---------------------------------- #
function_exit()
{
if [ "$RESULT" == "OK" ]; then
  echo "OK $RESULT_LOG"
  exit 0
elif [ "$RESULT" == "WARNING" ]; then
  echo "Warning $RESULT_LOG"
  exit 1
elif [ "$RESULT" == "CRITICAL" ]; then
  echo "Critical $RESULT_LOG"
  exit 2
else
  echo "Unknown $RESULT_LOG"
  exit 3
fi
}

# ---------------------------------- #
# Main Method
# ---------------------------------- #
while getopts H:U:P:M:h option;
do
  case $option in
    H) hostname=$OPTARG;;
    U) username=$OPTARG;;
    P) password=$OPTARG;;
    M) mode=$OPTARG;;
    h) echo "$usage"
    exit 3;;
  esac
done

check_options
check_cluster
function_exit
