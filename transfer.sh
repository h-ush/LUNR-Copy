#!/bin/bash
##############################################################
#
# OFFICIAL SCP TRANSPORT SCRIPT
#
# Functionality:
#   This program will send files and directories across
#   devices on the same network to seamlessly allow users
#   have files stored in two locations. The program will
#   create a log file on both devices so users are aware
#   of the Secure Copy Activity that has perspired on their
#   device using this tool.
#
# Notes:
#   1. Must create checks for files
#   2. Must make sure script is compatible with Windows
#   3. Set proper permissions on files as they are being
#      transferred across systems
#   4. Write a hash function to maintain integrity and
#      verify if hashes of files match
#   5. Write an encryption function to encrypt log data
#   6. GO CRAZY HAVE FUN!
#
# Date Created: 07-03-2024
#
# Created by
#   Craig Edelin Jr
#
#                                           VERSION 1.0
#
##############################################################

DIRECTORY_PATH=""
USERNAME=""
IP=""
LOCATION=""
AGAIN=""

##############################################################
#
# Imports other shell scripts to the file
#
# ############################################################
source $(pwd)/utility.sh
source $(pwd)/logging.sh

##############################################################
#
# Reads user input for RSYNC Process
#
# ############################################################
function transfer_to_destination_device() {
  echo "----------------------------------------------------"
  read -p "[+] DESIRED DIRECTORY    || " DIRECTORY_PATH
  read -p "[+] DESTINATION USERNAME || " USERNAME
  read -p "[+] DESTINATION IP       || " IP
  read -p "[+] DESTINATION LOCATION || " LOCATION
  echo "----------------------------------------------------"

  rsync_content_check "$DIRECTORY_PATH" "$USERNAME" "$IP" "$LOCATION"
}

##############################################################
#
# Transfers the selected file or directory to the desired
# device using RSYNC
#
# ############################################################
function rsync_content_check() {
  local DIRECTORY_PATH=$1
  local USERNAME=$2
  local IP=$3
  local LOCATION=$4

  # Checks for a '~/' in user input for DIRECTORY_PATH so things
  # do not break
  if [[ "${DIRECTORY_PATH}" == "~/"* ]]; then
    DIRECTORY_PATH="/home/$(logname)/${DIRECTORY_PATH#"~/"}"
  fi

  local DIRECTORY_NAME=$(basename "${DIRECTORY_PATH}")
  local FIND_DIRECTORY=""
  local FIND_FILE=""

  # Gets the file or directory name from specified path
  # Checks to see if target file or directory exists on
  # SENDER'S device
  echo "DIRECTORY_PATH: $DIRECTORY_PATH"
  echo "DIRECTORY_NAME: $DIRECTORY_NAME"
  echo "----------------------------------------------------"

  if [[ -d "${DIRECTORY_PATH}" ]]; then
    FIND_DIRECTORY=$(find "/home/$(logname)" -type d -name "${DIRECTORY_NAME}" | grep "${DIRECTORY_PATH}")
    echo "FOUND DIRECTORY: " ${DIRECTORY_PATH}
    echo "FIND_DIRECTORY: $FIND_DIRECTORY"
    rsync --timeout=100 -r ${FIND_DIRECTORY} ${USERNAME}@${IP}:${LOCATION}
  elif [[ -f "${DIRECTORY_PATH}" ]]; then
    FIND_FILE=$(find "/home/$(logname)" -type f -name "${DIRECTORY_NAME}" | grep "${DIRECTORY_PATH}")
    echo "FOUND FILE: " ${DIRECTORY_PATH}
    echo "FIND_FILE: $FIND_FILE"
    rsync --timeout=100 -r ${FIND_FILE} ${USERNAME}@${IP}:${LOCATION}
  else
    echo ""
    logERROR "PATH TO '${DIRECTORY_PATH}' DOES NOT EXIST under /home/$(logname)"
    echo ""

    read -p "Would you like to try again (y/n)? " AGAIN
    case $AGAIN in
        y)
          transfer_to_destination_device
          ;;
        *)
          exit -1
          ;;
    esac
  fi

  # '$?' --> Gives the return code of the previous command
  if [[ ! "$?" -eq "0" ]]; then
    logERROR "RSYNC SSH HAS FAILED... ENDING SCRIPT"
    exit -1
  fi
}

##############################################################
#
# Ensures that the log data is updated on both the
# destination device and the senders device
#
##############################################################
function transfer_log_data_to_destination_device() {
  logINFO "ESTABLISHING SSH CONNECTION"
  ssh -t "${USERNAME}"@"${IP}" "${SUDO_PATH} mkdir -p ${LOG_LOCATION}"
  logINFO "MAKING LOG DIRECTORY ON TARGET DEVICE"

  sleep 5

  ssh -t "${USERNAME}"@"${IP}" "${SUDO_PATH} mv /tmp/${DATE_MADE} ${LOG_DIRECTORY}"
  logSUCCESS "LOG DATA TRANSFERRED TO TARGET"
}
