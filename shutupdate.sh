#!/bin/bash

SHUTDOWN=0
REBOOT=0
#DELAY=0

# Check if root
if [ "$UID" -ne 0 ]; then
    echo "Please run as root."
    exit
fi

# Shows you how to use the script
usage() { echo "Usage: $0 [-s <integer>] [-r <integer>]" 1>&2; exit 1; }

# Default behavior is just to update and upgrade but other options can be specified
while getopts ":s:r:" option
do
    case "${option}"
    in
        s)
            echo "Shutdown is true." >&2
            SHUTDOWN=1
            DELAY=${OPTARG}
            ;;
        r)
            echo "Reboot is true." >&2
            REBOOT=1
            DELAY=${OPTARG}
            ;;
        *)
            # Error checking for erroneous arguments
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# If no delay parameters are specified, assume 0
if [ -z "${DELAY}" ] 
then
    DELAY=0
fi

echo "System will wait for $DELAY second(s) after update"

# The part where you update and upgrade
aptitude update && aptitude full-upgrade -y

# Wait a little while
sleep $DELAY

# Checking of optional shutdown or restart conditionals
if [ $SHUTDOWN -eq 1 ]
then
    if [ $REBOOT -eq 1 ]
    then
        echo -e "\n\nBoth reboot and poweroff selected. Shutting down by default."
        sleep 1
    else
        echo -e "\n\nSystem shutting down."
    fi
    
    # Shut down the computer
    poweroff
    exit

elif [ $REBOOT -eq 1 ]
then
    echo -e "\n\nSystem rebooting."
    
    # Reboot the computer
    reboot
    exit
fi

