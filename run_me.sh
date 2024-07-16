#!/bin/bash

SUDO_PATH="/usr/bin/sudo"
DATE_MADE=$(date "+%d-%m-%Y") # Gets the current date from the device
LINUX_IP=$(hostname -I | cut -f1 -d ' ') # Gets the IP address of the SENDER

##############################################################
#
# Imports other shell scripts to the file
#
# ############################################################
source $(pwd)/transfer.sh
source $(pwd)/utility.sh
source $(pwd)/logging.sh

function main() {
  title_for_program

  environment_check

  transfer_to_destination_device

  log

  # transfer_log_data_to_destination_device

  find_log_file

  move_log_file_to_logs
  # hash_creation ${DIRECTORY}/*
}

main
