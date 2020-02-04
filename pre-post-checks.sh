#!/bin/bash

# This script is intended to collect the pre and post check for the PTS, SPB and SDE
# elements prior and after a Maintenance Window or deployment.
#
# HOW TO USE THIS SCRIPT
#
# 1. Prepare the script as required for your deployment
#    This script already contains a list of standard commands to verify, if extra
#    commands are required add new lines to the lists provided below (there is a
#    list for every element).
#
#    To add a new command, add a new entry to the list with the following format:
#    'svcli -c "<command>"' \                         (for a cli/svcli command)
#    '<command>' \                                    (for non cli/svcli command)
#    '<command> && svcli -c "<command>" && <command>' (for multiple commands)
#
# 2. Upload the script "pre-post-checks.sh" to the element in /d2/tmp (suggested)
#
# 3. Give it execution permissions:
#    # chmod 744 pre-post-checks.sh
#
# 4. Execute the script:
#    # ./pre-post-checks.sh
#
# 5. Choose one of the options:
#
#    Please select an option:
#    1) Pre-Checks
#    2) Post-Checks
#    3) Exit/Cancel
#    #?
#
# 6. Wait for the script to complete and review the output file:
#
#    Prechecks/postcheck output saved as "{pre|post}-checks-{pts|spb|sde}-{hostname}-{date}.txt",
#    in the current directory.
#
#

###############################################################################
# COMMAND LIST
###############################################################################

# PTS specific commands
# Add new commands by adding a new entry to the list.
pts_commands=( \
'svcli -c "show alarms all"' \
'svcli -c "show alarms history"' \
'tail -100 /var/log/svlog' \
'svcli -c "show system services"' \
'svcli -c "show system resources"' \
'svcli -c "show system resources 67"' \
'svcli -c "show system overview"' \
'svcli -c "show service cluster-discovery elements"' \
'cd /d2/tmp/ && df -h .' \
'svcli -c "show system version detail"' \
'svcli -c "show service load-balancer modules detail"' \
'svcli -c "show interface configuration"' \
'svcli -c "show interface rate"' \
'svcli -c "show traffic"' \
'svcli -c "show service spb connections"' \
'svcli -c "show service subscriber-management stats"' \
'svcli -c "show service diameter peer"' \
'svcli -c "show usage-management online-charging stats"' \
'svcli -c "show usage-management online-charging errors"' \
'svcli -c "show usage-management policy-enforcement stats detail"' \
'svcli -c "show usage-management policy-enforcement error-events"' \
'svcli -c "show usage-management record-generator stats"' \
'svcli -c "show usage-management record-generator errors"' \
'svcli -c "show network-business-intelligence base config"' \
'svcli -c "show network-business-intelligence real-time-entertainment config"' \
'svtechsupport' \
'svhealthcheck' \
)

# SPB specific commands
# Add new commands by adding a new entry to the list.
spb_commands=( \
'svcli -c "show alarms all"' \
'svcli -c "show alarms history"' \
'tail -100 /var/log/svlog' \
'tail -100 /var/log/jboss-server.log' \
'tail -100 /var/log/sonicmq.log' \
'svcli -c "show system services"' \
'svcli -c "show system resources"' \
'svcli -c "show system resources 67"' \
'svcli -c "show system overview"' \
'df -h' \
'svcli -c "show system version detail"' \
'svcli -c "show network-element"' \
'svcli -c "show service database status"' \
'svcli -c "show service subscriber-management stats persistence"' \
'svcli -c "show service subscriber-provisioning stats"' \
'svcli -c "show service ip-user-map stats"' \
'svtechsupport' \
'svhealthcheck' \
)

# SDE specific commands
# Add new commands by adding a new entry to the list.
sde_commands=( \
'svcli -c "show alarms all"' \
'svcli -c "show alarms history"' \
'tail -100 /var/log/svlog' \
'tail -50 /var/log/messages' \
'svcli -c "show system services"' \
'svcli -c "show system resources"' \
'svcli -c "show system resources 67"' \
'svcli -c "show system overview"' \
'df -h' \
'svcli -c "show system version detail"' \
'svcli -c "show service spb connections"' \
'svcli -c "show service subscriber-management stats"' \
'svcli -c "show service subscriber-provisioning stats"' \
'svcli -c "show service subscriber-mapping overview"' \
'svcli -c "show service radius server messages"' \
'svcli -c "show service dhcp stats"' \
'svcli -c "show service gtpc messages"' \
'svcli -c "show service persistency status"' \
'svcli -c "show config service failover-cluster"' \
'svcli -c "show service failover-cluster"' \
'svcli -c "show service failover-cluster vip"' \
'svcli -c "show usage-management record-generator stats"' \
'svcli -c "show usage-management record-generator errors"' \
'svcli -c "show service logging log-file"' \
'svcli -c "show usage-management quota-manager stats"' \
'svcli -c "show usage-management quota-manager errors history"' \
'svtechsupport' \
'svhealthcheck' \
)

##############################################################################
# DO NOT EDIT UNDER THIS SECTION
##############################################################################

file_name=""
sandvine_element=""

execute_command () {

  echo "Executing $1..."
  echo -e "\n\n##############################################################################" >> $file_name
  echo -e "$1\n" >> $file_name
  echo "$(eval $1)" >> $file_name
}

##############################################################################
##############################################################################

echo -e "
#################################################\n\
# Pre and Post Checks\n\
#################################################\n\n"

###############################################################################
#Set element
sandvine_element=$(svcli -c "show system version" | egrep -wo 'PTS|SPB|SDE' | tr "[:upper:]" "[:lower:]")

###############################################################################
# Select pre-check or post-check
echo "Please select an option:"
options=("Pre-Checks" "Post-Checks" "Exit/Cancel")

select opt in "${options[@]}"
do
    case $opt in
        "Pre-Checks")
            file_name="pre-checks-$sandvine_element-$HOSTNAME-$(date "+%Y-%m-%d").txt"
            break
            ;;
        "Post-Checks")
            file_name="post-checks-$sandvine_element-$HOSTNAME-$(date "+%Y-%m-%d").txt"
            break
            ;;
        "Exit/Cancel")
            exit
            ;;
        *) echo You have selected an invalid option.;;
    esac
done

###############################################################################
# Execute the command list according to the element

echo "" > $file_name

if [ "${sandvine_element}" = 'pts' ]; then
  echo "pts"
  for cmd in "${pts_commands[@]}"; do execute_command "$cmd"; done
elif [ "${sandvine_element}" = 'spb' ]; then
  echo "spb"
  for cmd in "${spb_commands[@]}"; do execute_command "$cmd"; done
else
  echo "sde"
  for cmd in "${sde_commands[@]}"; do execute_command "$cmd"; done
fi

# Show where the output has been saved
echo -e "\n##############################################################################"
echo -e "\nPrechecks/Postchecks output saved in $(pwd)/$file_name\n"
exit 0



